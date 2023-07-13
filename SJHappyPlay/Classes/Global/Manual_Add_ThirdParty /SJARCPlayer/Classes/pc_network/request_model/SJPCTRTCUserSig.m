#import "SJPCTRTCUserSig.h"
#import "PPUserInfoService.h"
@implementation SJPCTRTCUserSig
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.userid = [PPUserInfoService get_Instance].access_token;
  }
  return self;
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/getUserSig"];
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCTRTCUserSigReposeModal");
}
@end
