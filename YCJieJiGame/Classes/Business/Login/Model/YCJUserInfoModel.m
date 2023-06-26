//
//  YCJUserInfoModel.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/1.
//

#import "YCJUserInfoModel.h"

@implementation MemberLevelDto

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"levelId": @[@"id"]};
}

@end

@implementation YCJToken

@end

@implementation YCJUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nickName": @[@"nickname",@"nickName"], @"tokenModel": @"accessToken"};
}

@end
