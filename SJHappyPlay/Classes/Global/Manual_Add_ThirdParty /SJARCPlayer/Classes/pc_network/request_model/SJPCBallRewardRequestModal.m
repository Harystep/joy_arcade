#import "SJPCBallRewardRequestModal.h"
@implementation SJPCBallRewardRequestModal
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/ball/reward"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCBallRewardResponseModal");
}
@end
