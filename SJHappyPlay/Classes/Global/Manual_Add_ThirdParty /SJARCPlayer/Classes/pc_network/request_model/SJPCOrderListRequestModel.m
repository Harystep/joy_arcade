#import "SJPCOrderListRequestModel.h"
@implementation SJPCOrderListRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/order/list"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCOrderListResponseModel");
}
@end
