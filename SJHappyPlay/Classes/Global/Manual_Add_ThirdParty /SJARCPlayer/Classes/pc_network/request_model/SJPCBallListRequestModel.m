#import "SJPCBallListRequestModel.h"
@implementation SJPCBallListRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/doll/giftBox"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCBallListResponseModel");
}
@end
