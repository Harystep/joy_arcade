#import "PPApplePayModule.h"
#import <StoreKit/StoreKit.h>
#import "PPSandBoxHelper.h"
#import "SJPCChargeCoinByAppleCheckRequestModel.h"
#import "PPUserInfoService.h"
#import "PPGameConfig.h"
#import "AppDefineHeader.h"

@interface PPApplePayModule ()<SKProductsRequestDelegate>
@property (nonatomic, strong) NSString * order;
@property (nonatomic,copy) NSString *orderSn;
@property (nonatomic, strong) SKPaymentTransaction * currentPaymentTransaction;
@end
@implementation PPApplePayModule

static PPApplePayModule * instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPApplePayModule alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        if ([self getLastPaymentProjectId]) {
            NSLog(@"当前最后的支付的存单");
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
    }
    return self;
}
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)putCurrentPaymentProjectId:(NSString * )projectId{
    [[NSUserDefaults standardUserDefaults] setObject:projectId forKey:@"lastPaymentProject"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)finishCurrentPayment {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastPaymentProject"];
}
- (NSString *)getLastPaymentProjectId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPaymentProject"];
}
- (void)finishTransactionForAp {
    if (self.currentPaymentTransaction) {
        [[SKPaymentQueue defaultQueue] finishTransaction: self.currentPaymentTransaction];
    }
}
- (void)clearAllUncompleteTransaction:(ApplyPayBlock)block {
    NSString * projectId = [self getLastPaymentProjectId];
    if (projectId) {
        NSLog(@"这里存在一笔上次没有结算完成的订单，%@",projectId);
        [self payWithaSJProjectId:projectId];
    }
}
- (void)pay:(NSString *)projectId withBlock:(ApplyPayBlock)block withFaileBlock:(ApplePayFailBlock)failBlock {
    [self removeAllUncompleteTransactionsBeforeNewPurchase];
    NSString * aSJProjectId = projectId;
    self.payBlock = block;
    self.payFailBlock = failBlock;
    self.order = projectId;
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:aSJProjectId];
    }else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        if (self.payFailBlock) {
            self.payFailBlock(@"禁止应用内付费购买");
        }
    }
}
- (void)pay:(NSString *)projectId withOrderId:(NSString *)oriderId orderSn:(NSString *)orderSn withBlock:(ApplyPayBlock)block withFaileBlock:(ApplePayFailBlock)failBlock {
    self.order = oriderId;
    self.orderSn = orderSn;
    [self removeAllUncompleteTransactionsBeforeNewPurchase];
    NSString * aSJProjectId = projectId;
    self.payBlock = block;
    self.payFailBlock = failBlock;
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:aSJProjectId];
    }else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        if (self.payFailBlock) {
            self.payFailBlock(@"禁止应用内付费购买");
        }
    }
}
- (void)pay:(NSString *)projectId withBlock:(ApplyPayBlock)block {
    [self removeAllUncompleteTransactionsBeforeNewPurchase];
    NSString * aSJProjectId = projectId;
    self.payBlock = block;
    self.order = projectId;
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:aSJProjectId];
    }else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        if (self.payFailBlock) {
            self.payFailBlock(@"禁止应用内付费购买");
        }
    }
}
- (void)payWithaSJProjectId:(NSString * )aSJProjectId {
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:aSJProjectId];
    }else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        if (self.payFailBlock) {
            self.payFailBlock(@"禁止应用内付费购买");
        }
    }
}
- (void)getProductInfo:(NSString * )projectID{
    NSSet *set = [NSSet setWithArray:@[projectID]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    [self putCurrentPaymentProjectId:self.order];
}
#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        if (self.payFailBlock) {
            self.payFailBlock(@"无法获取产品信息，购买失败。");
        }
        return;
    }
    NSLog(@"支付商品，获取到的请求，然后请求支付");
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"[paymentQueue] ----> %ld ： %@", (long)transaction.transactionState, transaction.transactionDate);
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    self.currentPaymentTransaction = transaction;
    NSString *transactionReceiptString= nil;
    NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
    NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
    transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"apple 购买凭证 = %@", transactionReceiptString);
    [self sendTransactionReceipt:transactionReceiptString];
}
- (void)sendTransactionReceipt:(NSString *)receipt {
    SJPCChargeCoinByAppleCheckRequestModel * requestModel = [[SJPCChargeCoinByAppleCheckRequestModel alloc] init];
    requestModel.receipt = receipt;
    if (!self.order && [self getLastPaymentProjectId]) {
        self.order = [self getLastPaymentProjectId];
    }
    requestModel.orderSn = self.orderSn;
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if (!error) {
            if (self.payBlock){
                self.payBlock(receipt);
            }
            [[SKPaymentQueue defaultQueue] finishTransaction: self.currentPaymentTransaction];
            [self finishCurrentPayment];
        } else {
            if (self.payFailBlock) {
                self.payFailBlock(ZCLocal(@"购买失败"));
            }
        }
    }];
}
- (NSString * )getTransactionReceiptString {
    NSString *transactionReceiptString= nil;
    NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
    NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
    transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return transactionReceiptString;
}
#pragma mark -- 结束上次未完成的交易
-(void)removeAllUncompleteTransactionsBeforeNewPurchase{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count >= 1) {
        for (NSInteger count = transactions.count; count > 0; count--) {
            SKPaymentTransaction* transaction = [transactions objectAtIndex:count-1];
            if (transaction.transactionState == SKPaymentTransactionStatePurchased||transaction.transactionState == SKPaymentTransactionStateRestored) {
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }
        }
    }else{
        NSLog(@"没有历史未消耗订单");
    }
}
#pragma mark -- 存储订单,防止走漏单流程是获取不到Order 且苹果返回order为nil
-(void)saveOrderByInASJPurchase:(SKPaymentTransaction *)transaction{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString * order = self.order;
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [PPSandBoxHelper tempOrderPath], order];
    [dic setValue:order forKey:transaction.transactionIdentifier];
    BOOL ifWriteSuccess = [dic writeToFile:savedPath atomically:YES];
    if (ifWriteSuccess) {
        NSLog(@"根据事务id存储订单号成功!订单号为:%@  事务id为:%@",order,transaction.transactionIdentifier);
    }
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        if (self.payFailBlock) {
            self.payFailBlock(ZCLocal(@"购买失败"));
        }
    } else {
        NSLog(@"用户取消交易");
        if (self.payFailBlock) {
            self.payFailBlock(ZCLocal(@"用户取消交易"));
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    //    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSLog(@"[restoreTransaction] ——> 恢复购买");
    if ([self getLastPaymentProjectId]) {
        [self completeTransaction:transaction];
    }
}

@end
