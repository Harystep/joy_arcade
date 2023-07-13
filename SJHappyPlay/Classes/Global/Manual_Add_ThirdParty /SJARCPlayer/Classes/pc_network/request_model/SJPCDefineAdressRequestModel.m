#import "SJPCDefineAdressRequestModel.h"
@implementation SJPCDefineAdressRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/address/default"];
}
- (Class)responseClass
{
    return NSClassFromString(@"PCDefineAdressResponseModel");
}
@end
