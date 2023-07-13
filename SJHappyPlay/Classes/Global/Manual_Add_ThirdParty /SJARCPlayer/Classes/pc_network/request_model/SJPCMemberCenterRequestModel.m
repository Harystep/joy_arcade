#import "SJPCMemberCenterRequestModel.h"
@implementation SJPCMemberCenterRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/member/center/v15"];
}
- (Class)responseClass
{
    return NSClassFromString(@"PCMemberCenterResponseModel");
}
@end
