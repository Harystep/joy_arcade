#import "SJPCChargeCoinByAppleCheckRequestModel.h"
#import "PPNetworkConfig.h"
@implementation SJPCChargeCoinByAppleCheckRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/ios/pay/v3"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}

- (NSDictionary *)httpHeader {
    return @{
        @"channelKey": [PPNetworkConfig sharedInstance].channelKey,
    };
}
@end
