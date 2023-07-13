//
//  PPThirdSyncRequestModel.m
//  wawajiGame
//
//  Created by sander shan on 2023/3/13.
//

#import "PPThirdSyncRequestModel.h"

#import "NSString+MD5.h"

@implementation PPThirdSyncRequestModel


- (instancetype)initWithOauthId:(NSString * )oauthId platform:(NSInteger)platform nickname:(NSString *) nickname avatar:(NSString *)avatar
{
    self = [super init];
    if (self) {
        _oauthId = oauthId;
        _platform = platform;
        _nickname = nickname;
        _avatar = avatar;
        _channelKey = [PPNetworkConfig sharedInstance].channelKey;
        NSString * signValue = [NSString stringWithFormat:@"%@|%@", [PPNetworkConfig sharedInstance].channelKey, oauthId];
        _sign = [[signValue getMd5] lowercaseString];
    }
    return self;
}

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/third/sync"];
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}
- (Class)responseClass
{
    return NSClassFromString(@"SJPCWeiXinLoginResponseModel");
}
- (BOOL)isShowHub
{
    return true;
}

@end
