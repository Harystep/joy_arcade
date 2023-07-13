#import "SJPCSharedRecordRequestModel.h"
@implementation SJPCSharedRecordRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/share/record"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_FORM;
}
@end
