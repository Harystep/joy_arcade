#import "SJPCChargeListRequestModel.h"
@implementation SJPCChargeListRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{///list/channel/v2   charge/list/ios/channel
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/list/channel/v3"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCChargeListResponseModel");
}
@end
