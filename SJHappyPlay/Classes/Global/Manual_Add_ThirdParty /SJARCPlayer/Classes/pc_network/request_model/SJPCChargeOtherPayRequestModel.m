#import "SJPCChargeOtherPayRequestModel.h"
@implementation SJPCChargeOtherPayRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/otherPay"];
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"b_id":@"id"};
}
- (Class)responseClass
{
  return NSClassFromString(@"PPChargeOtherPayResponseModel");
}
@end
