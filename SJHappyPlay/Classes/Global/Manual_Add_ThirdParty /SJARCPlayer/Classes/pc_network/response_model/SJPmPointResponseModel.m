#import "SJPmPointResponseModel.h"
@implementation SJPmPointResponseModel
@end
@implementation SDPmPointUnitDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
  return @{@"pmId": @"id"};
}
@end
@implementation SDPMPointChargeInfo
+ (NSDictionary * )mj_objectClassInArray {
  return @{@"list": @"SDPmPointUnitDataModel"};
}
@end
