#import "SJPCExchagneCointByPointRequestModel.h"
@implementation SJPCExchagneCointByPointRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/pm/exchange/coin"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
@end
