#import "PPRechargeLogRequestModel.h"
@implementation PPRechargeLogRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/log/v15"];
}
- (Class)responseClass{
    return [PPRechargeLogResponseModel class];
}
@end
