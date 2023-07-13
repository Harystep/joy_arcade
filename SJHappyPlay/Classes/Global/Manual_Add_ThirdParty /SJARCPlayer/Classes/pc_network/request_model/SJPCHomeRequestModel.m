#import "SJPCHomeRequestModel.h"
#import "SJPCHomeResponseModel.h"
@implementation SJPCHomeRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/home/tag"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (Class)responseClass
{
    return [SJPCHomeResponseModel class];
}
@end
