#import "SJPCAppUpDataRequeseModel.h"
@implementation SJPCAppUpDataRequeseModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/home/update"];
}
- (Class)responseClass
{
    return [SJPCAppUpDataResponseModel class];
}
@end
