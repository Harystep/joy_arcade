#import "SJPCAppealRequestModel.h"
@implementation SJPCAppealRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/doll/appeal/v15"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"a_id":@"id"};
}
@end
