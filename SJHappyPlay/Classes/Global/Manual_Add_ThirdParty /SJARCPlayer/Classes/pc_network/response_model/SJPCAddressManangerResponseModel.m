#import "SJPCAddressManangerResponseModel.h"
@implementation SJPCAddressManangerResponseModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"PCAddressManangerListModel"};
}
@end
@implementation PCAddressManangerListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"SDAddressUnitModel"};
}
@end
