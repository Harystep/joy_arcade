#import "SJPCAddressSetDefineRequestModel.h"
@implementation SJPCAddressSetDefineRequestModel
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"address_id":@"id"};
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/address/default"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
@end
