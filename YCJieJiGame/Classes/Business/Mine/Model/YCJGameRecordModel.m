//
//  YCJGameRecordModel.m
//  YCJieJiGame
//
//  Created by John on 2023/6/2.
//

#import "YCJGameRecordModel.h"

@implementation YCJGameDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"detailId": @[@"id"]};
}

@end

@implementation YCJGameRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"recordId": @[@"id"]};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"YCJGameDetailModel"};  //前边，是属性数组的名字，后边就是类名
}
@end
