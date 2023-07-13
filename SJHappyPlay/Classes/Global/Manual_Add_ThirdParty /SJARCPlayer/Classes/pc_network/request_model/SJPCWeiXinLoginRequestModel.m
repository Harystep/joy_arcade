#import "SJPCWeiXinLoginRequestModel.h"
#import "SJPCWeiXinLoginResponseModel.h"
@implementation SJPCWeiXinLoginRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/oauth/login"];
}
- (Class)responseClass
{
    return [SJPCWeiXinLoginResponseModel class];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.platform = 3;
    }
    return self;
}
@end
