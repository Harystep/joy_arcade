#import "SJPCLoginRequestModel.h"
@implementation SJPCLoginRequestModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.platform = 3;
    }
    return self;
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/login"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCWeiXinLoginResponseModel");
}
- (BOOL)isShowHub
{
    return true;
}
@end
