#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SDBallRewardModal;
@interface SJPCBallRewardResponseModal : PPResponseBaseModel
@property (nonatomic, strong) NSArray<SDBallRewardModal * > * data;
@end
@interface SDBallRewardModal : NSObject
@property (nonatomic, strong) NSString * reward_id;
@property (nonatomic, strong) NSString * machineId;
@property (nonatomic, strong) NSString * ballNum;
@property (nonatomic, assign) NSInteger rewardLevel;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, assign) BOOL isReward;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imgs;
@property (nonatomic, strong) NSString * rewardName;
@end
NS_ASSUME_NONNULL_END
