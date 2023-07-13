#import "SJPCUserInfoRequestModel.h"
@implementation SJPCUserInfoRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/user/info/v15"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCWeiXinLoginResponseModel");
}
@end
