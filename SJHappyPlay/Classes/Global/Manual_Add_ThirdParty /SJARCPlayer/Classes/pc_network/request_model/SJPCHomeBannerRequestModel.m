#import "SJPCHomeBannerRequestModel.h"
@implementation SJPCHomeBannerRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/banner"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCHomeBannerResponseModel");
}
@end
