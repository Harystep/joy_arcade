#import "SJPCRefreshTokenRequestModel.h"
@implementation SJPCRefreshTokenRequestModel
- (HTTP_METHOD)httpMethod{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/refreshToken"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCRefreshTokenResponseModel");
}
@end
