#import "SJPCUserWelfareTaskRequestModel.h"
@implementation SJPCUserWelfareTaskRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/user/task/v15"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCUserWelfareTaskResponseModel");
}
@end
