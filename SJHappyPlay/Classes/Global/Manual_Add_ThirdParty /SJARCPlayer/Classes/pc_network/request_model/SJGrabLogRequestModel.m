#import "SJGrabLogRequestModel.h"
@implementation SJGrabLogRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/doll/log"];
}
- (Class)responseClass
{
    return NSClassFromString(@"PPGrabLogResponseModel");
}
@end
