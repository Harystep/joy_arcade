#import "SJPCBallRewardResponseModal.h"
@implementation SJPCBallRewardResponseModal
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"SDBallRewardModal"};
}
@end
@implementation SDBallRewardModal
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"reward_id":@"id"};
}
@end
