#import <UIKit/UIKit.h>
#import "PPTcpReceviceData.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPGamePlayerView : UIView
@property (nonatomic, strong) SDPlayerInfoModel * currentPlayer;
@property (nonatomic, strong) NSArray<SDPlayerInfoModel * > * waitPlayerList;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) NSInteger waitMemberCount;
@end
NS_ASSUME_NONNULL_END
