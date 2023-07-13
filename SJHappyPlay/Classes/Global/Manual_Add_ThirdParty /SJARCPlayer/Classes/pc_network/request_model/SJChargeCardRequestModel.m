//
//  SJChargeCardRequestModel.m
//  wawajiGame
//
//  Created by sander shan on 2023/3/9.
//

#import "SJChargeCardRequestModel.h"

@implementation SJChargeCardRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/card/buy"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"b_id":@"id"};
}
- (Class)responseClass
{
  if (self.type == 1 || self.type == 3) {
        return NSClassFromString(@"PPChargeOtherPayResponseModel");
    }else if (self.type == 2){
        return NSClassFromString(@"SDChargeWeiXinPayResponseModel");
    }
    return [PPResponseBaseModel class];;
}
@end
