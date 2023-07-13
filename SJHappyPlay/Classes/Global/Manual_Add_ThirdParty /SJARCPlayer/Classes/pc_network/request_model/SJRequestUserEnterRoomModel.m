

#import "SJRequestUserEnterRoomModel.h"

@implementation SJRequestUserEnterRoomModel

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/room/enter/v2"];
}
- (Class)responseClass{
    return NSClassFromString(@"SJResponseUserEnterRoomModel");
}

- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}

@end
