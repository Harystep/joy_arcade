#import "SJPCMessageRequestModel.h"
@implementation SJPCMessageRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/messages"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCMessageResponseModel");
}
@end
