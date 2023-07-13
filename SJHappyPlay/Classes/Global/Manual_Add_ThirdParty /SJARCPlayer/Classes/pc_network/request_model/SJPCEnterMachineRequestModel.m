#import "SJPCEnterMachineRequestModel.h"
#import "SJPCEnterMatchineResponseModel.h"
@implementation SJPCEnterMachineRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/enter/room"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (Class)responseClass
{
    return [SJPCEnterMatchineResponseModel class];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (BOOL)isShowHub {
  return true;
}
@end
