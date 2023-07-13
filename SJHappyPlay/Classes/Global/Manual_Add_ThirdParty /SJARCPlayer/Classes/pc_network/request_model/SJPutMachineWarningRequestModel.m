#import "SJPutMachineWarningRequestModel.h"
@implementation SJPutMachineWarningRequestModel
- (instancetype)initWithmachineSn:(NSString *)sn {
  self = [super init];
  if (self) {
    _machineSn = sn;
    _warningStatus = @"1";
  }
  return self;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/machine/warning"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (Class)responseClass
{
    return [PPResponseBaseModel class];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (BOOL)isShowHub {
  return true;
}
@end
