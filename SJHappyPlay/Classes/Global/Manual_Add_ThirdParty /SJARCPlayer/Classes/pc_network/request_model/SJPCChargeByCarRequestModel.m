#import "SJPCChargeByCarRequestModel.h"
#import "PPChargeOtherPayResponseModel.h"
@implementation SJPCChargeByCarRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/card/v15"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (Class)responseClass
{
    if (self.type == 1) {
        return NSClassFromString(@"PPChargeOtherPayResponseModel");
    }else if (self.type == 2){
        return NSClassFromString(@"SDChargeWeiXinPayResponseModel");
    }
    return [PPResponseBaseModel class];;
}
@end
