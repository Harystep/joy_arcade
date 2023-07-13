#import "SJPCPMPointRequestModel.h"
@implementation SJPCPMPointRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/pm/option"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPmPointResponseModel");
}
@end
