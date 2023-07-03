

#import "YCJGameRoomModel.h"

@implementation YCJGameRoomGroup
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"roomGroupId": @[@"id"]};
}

@end

@implementation YCJGameRoomModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"gameId": @[@"id"]};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roomGroupList" : @"YCJGameRoomGroup"};  //前边，是属性数组的名字，后边就是类名
}

@end
