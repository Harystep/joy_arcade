#import "SJPCMessagesCountRequestModel.h"
@implementation SJPCMessagesCountRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/messages/count"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCMessagesCountResponseModel");
}
- (BOOL)checkResponseSucess
{
    return false;
}
@end
