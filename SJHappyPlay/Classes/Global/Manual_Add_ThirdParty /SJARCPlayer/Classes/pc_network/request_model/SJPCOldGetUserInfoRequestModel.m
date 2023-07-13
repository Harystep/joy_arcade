#import "SJPCOldGetUserInfoRequestModel.h"
@implementation SJPCOldGetUserInfoRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/user/info"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCWeiXinLoginResponseModel");
}
- (BOOL)checkResponseSucess
{
    return false;
}
@end
