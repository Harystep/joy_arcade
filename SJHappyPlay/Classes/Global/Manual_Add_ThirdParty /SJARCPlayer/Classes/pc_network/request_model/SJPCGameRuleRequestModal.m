#import "SJPCGameRuleRequestModal.h"
@implementation SJPCGameRuleRequestModal
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/game/rule"];
}
- (Class)responseClass{
    return [SJPCGameRuleResponseModal class];
}
@end
