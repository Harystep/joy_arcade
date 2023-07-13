#import "SJPCAddNewAddressRequestModel.h"
@implementation SJPCAddNewAddressRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString *)requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/address"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"address_id":@"id"};
}
@end
