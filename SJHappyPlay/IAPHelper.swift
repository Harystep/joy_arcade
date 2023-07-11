//
//  IAPHelper.swift
//  JQComponentLib
//
//  Created by John on 2022/4/19.
//

import Foundation
import SwiftyStoreKit
import StoreKit

@objcMembers class IAPHelper: NSObject {
    
    private override init() {}
    public static let shared = IAPHelper()
    /// 订单ID
    private var orderId: String?
    /// 购买成功核对完成回调
    public var paymentSuccessfulCallBack: (() -> Void)?
    /// 取消购买回调
    public var paymentCancelledCallBack: ((String) -> Void)?
    public var productId = ""
    /// 周卡月卡：card:{id} ; 普通充值：option:{id}
    public var productType = ""
    public var goodid = ""
    
    
    /// 启动时设置IAP
    public func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    }
                    
                    /// Deliver content from server, then:
                    if let product = self.readStoreProductWithProductId(purchase.productId) {
                        product.transaction = purchase.transaction
                        self.verificationCompleteTransaction(product)
                    } else {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break /// do nothing
                @unknown default:
                    break /// do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in

            /// contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    /// 开始苹果支付
    public func startApplePay(product: String, goodId: String, type: String) {
        print("--\(product)--\(goodId)--\(type)")
        self.goodid = goodId
        self.productId = product
        self.productType = type
        if SKPaymentQueue.canMakePayments() {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.showAppStoreHUD(title: "Connecting App Store")
            }
            getOrderNumber()
        } else {
            /// 用户未开启内购，弹框提示
            UIApplication.shared.keyWindow?.showError("请在“设置 - 屏幕使用时间 - 内容和隐私访问限制 - iTunes Store 与 App store 购买 - App内购项目”中选择“允许”，开启内购功能")
        }
    }
    
    /// 获取订单号
    func getOrderNumber() {
        let parameters:[String : Any] = [
            "productId" : "\(self.productType):\(goodid)"
        ]
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.showAppStoreHUD(title: "Connecting App Store")
        }
        JKNetWorkManager.postRequest(withUrlPath: JKIOSChongZhiDingDanUrlKey, parameters: parameters) { [weak self] res in
            guard let `self` = self else {return}
            if let errCode = res.resultObject["errCode"] as? Int, errCode == 0, let data = res.resultData as? [String:Any], let orderID = data["orderSn"] as? String {
                let order = String(format: "%@", orderID)
                print("订单号获取成功！！！\(order)")
                let product = SPIAPProduct()
                product.productId = self.productId
                product.orderId = order
                self.saveStoreProduct(product)
                self.orderId = order
                self.purchase(product: product)
            } else {
                print("订单号获取失败")
//                let msg = res.error.localizedDescription
//                self.showLoading(title: msg)
            }
        }
    }
    
    /// 购买
    func purchase(product: SPIAPProduct) {
        if let productId = product.productId {
            SwiftyStoreKit.purchaseProduct(productId) { (result) in
                switch result {
                case .success(let purchase):
                    print("购买成功啦！！！把回购凭证丢给服务器就好啦")
                    if let product = self.readStoreProductWithProductId(purchase.productId) {
                        product.purchase = purchase
                        product.transaction = purchase.transaction
                        self.verificationCompleteTransaction(product)
                    } else {
                        product.purchase = purchase
                        product.transaction = purchase.transaction
                        self.verificationCompleteTransaction(product)
                    }
                case .error(let error):
                    self.removeStoreProduct(product)
                    var errorMsg = ""
                    switch error.code {
                    case .unknown:
                        errorMsg = "未知错误，请联系支持"
                        self.paymentCancelledCallBack?(errorMsg)
                    case .clientInvalid:
                        errorMsg = "无效客户端"
                    case .paymentCancelled:
                        self.paymentCancelledCallBack?(errorMsg)
                    case .paymentInvalid:
                        errorMsg = "购买凭证无效"
                    case .paymentNotAllowed:
                        errorMsg = "不允许支付"
                    case .storeProductNotAvailable:
                        errorMsg = "该产品在当前店面中不可用"
                    case .cloudServicePermissionDenied:
                        errorMsg = "不允许访问云服务信息"
                    case .cloudServiceNetworkConnectionFailed:
                        errorMsg = "无法连接到网络"
                    case .cloudServiceRevoked:
                        errorMsg = "用户已撤销使用此云服务的权限"
                    default:
                        errorMsg = "用户取消购买"
                    }
                    if errorMsg.count != 0 {
                        print("Apple error:"+errorMsg)
                        self.showLoading(title: errorMsg)
                    }
                }
            }
        }
        
    }
    
    /// 验证已完成交易
    func verificationCompleteTransaction(_ product: SPIAPProduct, complete:((_ msg: String) -> Void)? = nil) {
        /// 服务器验证
        ///  let productId = product.productId,
        ///  let transactionId = transaction.transactionIdentifier
        if let orderId = product.orderId, let receipt = self.getReceipt(), receipt.count != 0, let transaction = product.transaction {
            let parameters:[String : Any] = [
                "orderSn": orderId,
                "receipt" : receipt,
            ]
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.showAppStoreHUD(title: "Connecting App Store")
            }
            JKNetWorkManager.postRequest(withUrlPath: JKIOSChongZhiUrlKey, parameters: parameters) { [weak self] res in
                guard let `self` = self else {return}
                if let errCode = res.resultObject["errCode"] as? Int, errCode == 0 {
                    /// 交易成功后再结束交易事务
                    self.removeStoreProduct(product)
                    SwiftyStoreKit.finishTransaction(transaction)
                    print("验证已完成，交易成功")
                    self.paymentSuccessfulCallBack?()
                    complete?("购买成功")
                } else {
                    let msg = res.resultObject["msg"] as? String ?? ""
                    complete?(msg)
                    self.showLoading(title: msg)
                }
            }
        } else {
            /// 服务器验证参数丢失，上报参数
//            let orderId = product.orderId ?? ""
//            let productId = product.productId ?? ""
//            let receipt = self.getReceipt() ?? ""
//            let transactionId = product.transaction?.transactionIdentifier ?? ""
//            let path = String(format: "orderId=%@,productId=%@,receipt=%@,transactionId=%@", orderId,productId,receipt,transactionId)
//            let url = "/nc-user-service/pay/applePay"
//            self.paymentAbnormalReportRequest(req: path, path: url, fail: "服务器验证参数丢失")
            self.showLoading(title: "购买参数错误")
            print("购买参数错误")
        }
    }
    
    /// 恢复购买
    public func restorePurchases(complete:((_ msg: String) -> Void)?) {

        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    if let product = self.readStoreProductWithProductId(purchase.productId) {
                        product.transaction = purchase.transaction
                        self.verificationCompleteTransaction(product)
                    } else {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
            }
            
            if results.restoreFailedPurchases.count > 0 {
                print("恢复失败: \(results.restoreFailedPurchases)")
                complete?("恢复失败")
            } else if results.restoredPurchases.count > 0 {
                print("恢复成功: \(results.restoredPurchases)")
                complete?("恢复成功")
            } else {
                print("无可恢复的权益")
                complete?("无可恢复的权益")
            }
        }
    }
    
    /// 重试失败的订单
    func retryFailedPurchases(complete:((_ msg: String) -> Void)?) {
        let transactions = SKPaymentQueue.default().transactions
        if transactions.count > 0 {
            for transaction in transactions {
                if let product = self.readStoreProductWithProductId(transaction.payment.productIdentifier) {
                    product.transaction = transaction
                    self.verificationCompleteTransaction(product, complete: complete)
                } else {
                    SwiftyStoreKit.finishTransaction(transaction)
                    complete?("恢复成功")
                }
            }
        } else {
            complete?("无可恢复的权益")
        }
    }
    
    /// 获取回购凭证
    func getReceipt() -> String? {
        
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: .endLineWithLineFeed)
//        print("receipt--->\(String(describing: receiptString))")
        return receiptString
    }
    
    /// 本地存储订单信息
    func saveStoreProduct(_ product: SPIAPProduct) {
        if let productId = product.productId, productId.count > 0 {
            let data = product.productInfoToPaymentData()
            if let productData = data, productData.count > 0 {
                do {
                    let path: URL = iapStorePathWithProductId(productId)
                    try productData.write(to: path)
                    print("-----存储成功：%s", path.absoluteString)
                } catch {
                    print("-----存储失败：%s", error.localizedDescription)
                }
            } else {
                print("-----存储失败：数据不存在")
            }
        } else {
            print("-----存储失败：数据不存在")
        }
    }
    
    /// 读取本地订单信息
    func readStoreProductWithProductId(_ productId: String) -> SPIAPProduct? {
        let path: URL = iapStorePathWithProductId(productId)
        if let productData = try? Data(contentsOf: path) {
            do {
                let productDict = try JSONSerialization.jsonObject(with: productData, options: JSONSerialization.ReadingOptions.mutableContainers)
                guard let result = productDict as? [AnyHashable: Any] else { return nil}
                if let orderId = result["orderId"] as? String, let pId = result["productId"] as? String {
                    let product = SPIAPProduct()
                    product.productId = pId
                    product.orderId = orderId
                    print("-----读取成功：%s,%s", pId, orderId)
                    return product
                }
            } catch {
                print("-----读取失败：%s", error.localizedDescription)
                return nil
            }
        } else {
            print("-----路径不存在，没有本地订单信息")
        }
        return nil
    }
    
    /// 删除订单信息
    func removeStoreProduct(_ product: SPIAPProduct) {
        if let productId = product.productId, productId.count > 0 {
            let path: URL = iapStorePathWithProductId(productId)
            try? FileManager.default.removeItem(at: path)
        }
    }
    
    /// 订单本地存储路径
    func iapStorePathWithProductId(_ productId: String) -> URL {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        let documentDirectory = directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        return documentDirectory.appendingPathComponent("\(productId).data")
    }
    
    func getIAPlocalPrice(){
        
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
}

extension IAPHelper {
    
    /// 支付异常上报请求
    func paymentAbnormalReportRequest(req:String,path:String,fail:String) {
//        let today = Date()
//        let reqString = String(format: "%@,time=%@", req,today as CVarArg)
//        let params = [
//            "req" : reqString,
//            "path" : path,
//            "fail" : fail
//        ]
//        BKNetwork.request(url: APIURL.bk_payErrorUploadInfo, methodType: .post, parameters: params, isNestedData: true, successCallBack: { result in
//            if let code = result["code"] as? Int, code == 0 {
//                print("上报成功")
//            } else {
//                print("flag不为0 HUD显示后台返回message"+"\(String(describing: result["msg"]))")
//            }
//        }, failureCallBack: { error in
//            print("error"+"\(String(describing: error.localizedDescription))")
//        })
    }
    
    /// 核对订单发货状态
//    private func checkoutOrderStatus(orderId: String) {
//        let checkoutReq = String(format: "orderId=%@", orderId)
//        let chechoutUrl = "/nc-user-service/pay/orderState"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
//            BKTopUpService.checkoutOrderStatus(orderNo: orderId) { (result) in
//                switch result {
//                case let .success(ORDER_STATUS):
//                    if ORDER_STATUS == .ORDER_GOTINGON {
//                        self.checkoutAgain(orderId)
//                    } else if ORDER_STATUS == .ORDER_SUCESS {
//                        /// 成功后回调
//                        self.paymentSuccessfulCallBack?()
//                        self.hud.dismiss()
//                    } else {
//                        self.hud.dismiss()
//                        UIApplication.shared.keyWindow?.makeToast("Payment failure")
//                        self.checkoutOrderAbnormalReport(req: checkoutReq, path: chechoutUrl, orderStatus: ORDER_STATUS)
//                    }
//                case let .failure(error):
//                    self.hud.dismiss()
//                    UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
//                    self.paymentAbnormalReportRequest(req: checkoutReq, path: chechoutUrl, fail: error.localizedDescription)
//              }
//            }
//        }
//    }
    
    /// 核对订单发货状态异常上报
//    func checkoutOrderAbnormalReport(req:String,path:String,orderStatus: ORDER_STATUS) {
//        var failMsg = ""
//        if  orderStatus == .ORDER_ABNORMAL {
//            failMsg = "Order exception"
//        }else if(orderStatus == .ORDER_NULL){
//            failMsg = "Order generation failed"
//        }else{
//            failMsg = "Payment failure"
//        }
//        paymentAbnormalReportRequest(req: req, path: path, fail: failMsg)
//    }
    
    /// 支付核对校验异常上报 （异常日志上传信息：当前的时间，orderId ，productId receipt transactionId 异常的msg）
//    func payVerifyAbnormalReport(orderId:String,productId:String,receipt:String,transactionId:String,fail:String) {
//        /// 支付异常
//        showLoading(title: "支付异常")
//        let paramerPath = String(format: "orderId=%@,productId=%@,receipt=%@,transactionId=%@", orderId,productId,receipt,transactionId)
//        let url = "/nc-user-service/pay/applePay"
//        paymentAbnormalReportRequest(req: paramerPath, path: url, fail: fail)
//    }
    
    /// 核对失败5s后继续核对
//    func checkoutAgain(_ orderNo: String) {
//        let repeatReq = String(format: "orderId=%@", orderNo)
//        let repeatUrl = "/nc-user-service/pay/orderState"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            BKTopUpService.checkoutOrderStatus(orderNo: orderNo) {[weak self] (result) in
//                guard let `self` = self else {return}
//                switch result {
//                case let .success(ORDER_STATUS):
//                    if ORDER_STATUS == .ORDER_GOTINGON {
//                        /// 失败后重试
//                        self.checkoutAgain(orderNo)
//                    } else if ORDER_STATUS == .ORDER_SUCESS {
//                        /// 成功后回调
//                        self.paymentSuccessfulCallBack?()
//                        self.hud.dismiss()
//                    } else {
//                        // 后续需要优化
//                        self.hud.dismiss()
//                        UIApplication.shared.keyWindow?.makeToast("Payment failure")
//                        self.checkoutOrderAbnormalReport(req: repeatReq, path: repeatUrl, orderStatus: ORDER_STATUS)
//                    }
//                case let .failure(error):
//                    self.hud.dismiss()
//                    UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
//                    self.paymentAbnormalReportRequest(req: repeatReq, path: repeatUrl, fail: "Payment failure")
//                }
//            }
//        }
//    }
    
    /// 如果title为"", 表示隐藏loading
    func showLoading(title: String) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.hide()
            if title.count > 0 {
                UIApplication.shared.keyWindow?.showHUD(title: title)
            }
        }
    }
}


class SPIAPProduct: NSObject {
    var productId: String?
    var orderId: String?
    var transaction: PaymentTransaction?
    var purchase: PurchaseDetails?
    
    func productInfoToPaymentData() -> Data? {
        
        var productDict: [String: Any] = [:]
        if let orderId = self.orderId, orderId.count > 0 {
            productDict["orderId"] = orderId
        }
        if let productId = self.productId, productId.count > 0 {
            productDict["productId"] = productId
        }
        
        let parameterData = try? JSONSerialization.data(withJSONObject: productDict, options: .prettyPrinted)
        return parameterData
    }
}
