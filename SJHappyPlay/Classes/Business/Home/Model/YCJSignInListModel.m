

#import "YCJSignInListModel.h"

@implementation YCJSignInDetailModel

@end

@implementation YCJSignInListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"YCJSignInDetailModel"};  //前边，是属性数组的名字，后边就是类名
}
@end
