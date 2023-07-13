#import "SJPCChargeListResponseModel.h"
@implementation SJPCChargeListResponseModel
@end
@implementation PCChargeTypeInfoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"optionList":@"PPChargeUnitModel",
//             ,@"month":@"PPChargeUnitModel",
//             @"week":@"PPChargeUnitModel",
             @"chargeOptions":@"PPChargeUnitModel"};
}
@end
