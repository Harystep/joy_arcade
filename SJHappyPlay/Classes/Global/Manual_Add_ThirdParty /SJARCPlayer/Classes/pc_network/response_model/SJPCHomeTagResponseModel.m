#import "SJPCHomeTagResponseModel.h"
@implementation SJPCHomeTagResponseModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"SDWaWaPageViewModel"};
}
@end


@implementation SDWaWaPageViewModel

+(NSDictionary * )mj_replacedKeyFromPropertyName {
  return @{@"tag_id": @"id"};
}

@end
