#import "SJPCAddressManangerRequestModel.h"
@implementation SJPCAddressManangerRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/address/list"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCAddressManangerResponseModel");
}
@end
