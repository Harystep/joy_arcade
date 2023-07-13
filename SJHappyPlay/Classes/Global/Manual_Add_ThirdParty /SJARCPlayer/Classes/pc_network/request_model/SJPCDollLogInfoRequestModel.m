#import "SJPCDollLogInfoRequestModel.h"
@implementation SJPCDollLogInfoRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/doll/log/info"];
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"d_id":@"id"};
}
- (Class)responseClass
{
    return [SJPCDollLogInfoResponseModel class];
}
@end
