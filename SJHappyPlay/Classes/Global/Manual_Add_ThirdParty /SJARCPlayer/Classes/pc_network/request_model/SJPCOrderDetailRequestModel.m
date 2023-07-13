#import "SJPCOrderDetailRequestModel.h"
@implementation SJPCOrderDetailRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/order/info"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCOrderDetailResponseModel");
}
@end
