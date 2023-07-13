#import "SJPCChargeRequestModel.h"
#import "PPResponseBaseModel.h"
@implementation SJPCChargeRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/ali/buy/v2"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"b_id":@"productId"};
}
- (Class)responseClass
{
  if (self.type == 3 || self.type == 2) {
        return NSClassFromString(@"PPChargeOtherPayResponseModel");
    }else if (self.type == 4){
        return NSClassFromString(@"SDChargeWeiXinPayResponseModel");
    }
    return [PPResponseBaseModel class];
}
@end
