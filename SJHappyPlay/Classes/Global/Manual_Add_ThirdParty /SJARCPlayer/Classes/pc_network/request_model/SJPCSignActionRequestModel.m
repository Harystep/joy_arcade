#import "SJPCSignActionRequestModel.h"
@implementation SJPCSignActionRequestModel
- (HTTP_METHOD)httpMethod{
    return HTTP_METHOD_POST;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/sign/v15"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
@end
