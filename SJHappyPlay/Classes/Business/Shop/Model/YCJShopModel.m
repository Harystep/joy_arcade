

#import "YCJShopModel.h"

@implementation YCJShopCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodsID": @[@"id"]};
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title containsString:@"月卡"] || [title containsString:@"周卡"]) {
        self.buyType = @"card";
    } else {
        self.buyType = @"option";
    }
}

- (NSString *)buyType {
    if (!_buyType) {
        return @"option";
    }
    return _buyType;
}

@end


@implementation YCJPaySupport

@end


@implementation YCJShopModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"optionList" : @"YCJShopCellModel"};  //前边，是属性数组的名字，后边就是类名
}
@end
