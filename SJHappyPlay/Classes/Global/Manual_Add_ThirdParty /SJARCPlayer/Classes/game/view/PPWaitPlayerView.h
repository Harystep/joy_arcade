#import <UIKit/UIKit.h>
#import "PPTcpReceviceData.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPWaitPlayerView : UIView
@property (nonatomic, strong) NSArray<SDPlayerInfoModel * > * waitPlayerList;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) BOOL showQuality;
@property (nonatomic, assign) NSInteger waitMemberCount;
- (instancetype)initWithShowQuality:(BOOL)show;
- (instancetype)initWithFrame:(CGRect)frame withShowQuality:(BOOL)show;
@end
NS_ASSUME_NONNULL_END
