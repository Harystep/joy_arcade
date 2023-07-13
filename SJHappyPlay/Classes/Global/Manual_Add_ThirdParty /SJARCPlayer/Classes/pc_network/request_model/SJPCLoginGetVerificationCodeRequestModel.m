#import "SJPCLoginGetVerificationCodeRequestModel.h"
#import "SJPCLoginGetVerificationCodeResponseModel.h"
@implementation SJPCLoginGetVerificationCodeRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/mobile/captcha"];
}
- (Class)responseClass
{
    return [SJPCLoginGetVerificationCodeResponseModel class];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
@end
