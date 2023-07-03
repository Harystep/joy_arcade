

#import "SKUserInfoModel.h"

@implementation MemberLevelDto

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"levelId": @[@"id"]};
}

@end

@implementation YCJToken

@end

@implementation SKUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nickName": @[@"nickname",@"nickName"], @"tokenModel": @"accessToken"};
}

@end
