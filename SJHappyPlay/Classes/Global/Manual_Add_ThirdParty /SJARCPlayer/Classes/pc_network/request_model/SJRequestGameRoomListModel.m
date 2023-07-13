

#import "SJRequestGameRoomListModel.h"

@implementation SJRequestGameRoomListModel

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/room/list/byroom"];
}
- (Class)responseClass{
    return NSClassFromString(@"SJResponseGameRoomListModel");
}

@end
