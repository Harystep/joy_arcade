

#import "YCJComplaintModel.h"

@implementation YCJComplaintAppeal

@end


@implementation YCJComplaintSettleLog

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"logId": @[@"id"]};
}

@end

@implementation YCJComplaintDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"complaintId": @[@"id"]};
}

@end

@implementation YCJComplaintModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"complaintId": @[@"id"]};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"YCJGameDetailModel"};  //前边，是属性数组的名字，后边就是类名
}

@end
