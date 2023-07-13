#import "SJPCDollLogRoomRequestBaseModel.h"
#import "PPGrabLogResponseModel.h"
@implementation SJPCDollLogRoomRequestBaseModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"doll/log/last"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_FORM;
}
- (Class)responseClass
{
    return [SDGrabLogListModel class];
}
@end
