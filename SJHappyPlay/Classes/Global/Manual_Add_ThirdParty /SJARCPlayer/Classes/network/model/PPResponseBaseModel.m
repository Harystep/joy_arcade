#import "PPResponseBaseModel.h"
@implementation PPResponseBaseModel
- (BOOL)checkSuccess
{
    if ([self.errCode integerValue] == 0) {
        return true;
    }else if ([self.errCode integerValue] == 20002 || [self.errCode integerValue] == 20001){
    }else{
    }
    return false;
}
+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    NSMutableArray *ignoreArray = [NSMutableArray arrayWithCapacity:0];
    [ignoreArray addObject:@"taskKey"];
    [ignoreArray addObject:@"debugDescription"];
    [ignoreArray addObject:@"description"];
    [ignoreArray addObject:@"hash"];
    [ignoreArray addObject:@"superclass"];
    return ignoreArray;
}
@end
