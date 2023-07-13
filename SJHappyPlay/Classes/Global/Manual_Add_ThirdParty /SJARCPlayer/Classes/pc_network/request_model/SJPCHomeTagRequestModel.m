#import "SJPCHomeTagRequestModel.h"
#import "SJPCHomeTagResponseModel.h"
@implementation SJPCHomeTagRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/tags"];
}
- (Class)responseClass
{
    return [SJPCHomeTagResponseModel class];
}
@end
