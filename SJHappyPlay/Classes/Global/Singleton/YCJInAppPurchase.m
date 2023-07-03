

#import "YCJInAppPurchase.h"
#import <StoreKit/StoreKit.h>

static NSString *InAppPurchaseFailRefuse = @"该商品暂时无法购买，请稍后重试";
static NSString *InAppPurchaseFailRequest = @"操作失败，请稍后重试";
static NSString *InAppPurchaseFailBuy = @"购买失败，请稍后重试";
static NSString *InAppPurchaseFailResume = @"恢复失败，您未购买过该商品";

@interface YCJInAppPurchase ()
<
SKPaymentTransactionObserver,
SKProductsRequestDelegate
>
{
    int _isResume;//是否恢复的购买
    NSString *_productId;//内购中的产品ID
}

@end

@implementation YCJInAppPurchase

- (id)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver];
}
- (void)removeObserver{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)launchInAppPurchase:(NSString *)productId{
    
    _isResume = 0;
    _productId = productId;
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:productId];
    }else{
        NSLog(@"不允许程序内付费");
    }
}

- (void)resumeInAppPurchase:(NSString *)productId{
    _isResume=1;
    _productId = productId;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息------:%@----------", type);
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        if([pro.productIdentifier isEqualToString:_productId]){
            p = pro;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    // 可以把我们的自己订单和IAP的交易订单绑定,本地存储订单信息
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    NSString *resultA=@"";
    SKPaymentTransaction *tran = [transaction lastObject];
    switch (tran.transactionState) {
        case SKPaymentTransactionStatePurchased:
            NSLog(@"交易完成");
            if (_isResume==0) {
                NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                resultA=[self encode:receiptData.bytes length:receiptData.length];
                NSLog(@"购买结果票据：%@",resultA);
                // 收据发送到服务器
                // 收据验证成功之后结束交易
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                // 删除保存的订单信息
            }
            else
            {
                NSString *resultB=[self encode:tran.transactionReceipt.bytes length:tran.transactionReceipt.length];
                NSLog(@"恢复结果票据：%@",resultB);
                // 收据发送到服务器
                // 收据验证成功之后结束交易
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
            
            break;
        case SKPaymentTransactionStatePurchasing:
            NSLog(@"商品添加进列表");
            break;
        case SKPaymentTransactionStateRestored:
            NSLog(@"已经购买过商品");
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            break;
        case SKPaymentTransactionStateFailed:
            NSLog(@"交易失败");
            NSLog(@"%ld",tran.error.code);
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            [self errorReason:tran.error];
            break;
        default:
            break;
    }
}

- (void)errorReason:(NSError *)error{
    NSString *detail;
    if (error != nil) {
        switch (error.code) {
            case SKErrorUnknown:
                NSLog(@"SKErrorUnknown");
                detail = @"未知的错误，您可能正在使用越狱手机";
                break;
            case SKErrorClientInvalid:
                NSLog(@"SKErrorClientInvalid");
                detail = @"当前苹果账户无法购买商品(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorPaymentCancelled:
                NSLog(@"SKErrorPaymentCancelled");
                detail = @"订单已取消";
                break;
            case SKErrorPaymentInvalid:
                NSLog(@"SKErrorPaymentInvalid");
                detail = @"订单无效(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorPaymentNotAllowed:
                NSLog(@"SKErrorPaymentNotAllowed");
                detail = @"当前苹果设备无法购买商品(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorStoreProductNotAvailable:
                NSLog(@"SKErrorStoreProductNotAvailable");
                detail = @"当前商品不可用";
                break;
            default:
                NSLog(@"No Match Found for error");
                detail = @"未知错误";
                break;
        }
    }
}
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}



@end
