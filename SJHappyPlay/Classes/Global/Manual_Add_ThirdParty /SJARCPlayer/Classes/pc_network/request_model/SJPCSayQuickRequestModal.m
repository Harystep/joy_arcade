#import "SJPCSayQuickRequestModal.h"
@implementation SJPCSayQuickRequestModal
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/say/quick"];
}
- (Class)responseClass{
    return [SJPCSayQuickResponseModal class];
}
@end
