#import "SJPCSignListRequestmodel.h"
@implementation SJPCSignListRequestmodel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/signList"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCSignListResponseModel");
}
@end
