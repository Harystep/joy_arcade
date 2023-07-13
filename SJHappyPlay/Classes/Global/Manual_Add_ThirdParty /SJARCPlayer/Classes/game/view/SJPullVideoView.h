#import <UIKit/UIKit.h>
#import "PPTrtcVideoView.h"
typedef enum : NSUInteger {
  SDPullViewForWawaji,
  SDPullViewForPushCoin,
  SDPullViewForSaint,
  SDPullViewForPushCoinGold,
  SDPullViewForGoldLegend,
} SDPullViewForDevice;
NS_ASSUME_NONNULL_BEGIN
@interface SJPullVideoView : UIView
@property (nonatomic, strong) NSString * roomId;
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, assign) NSInteger currentStreamIndex;
@property (nonatomic, assign) int quality;
@property (nonatomic, assign) SDPullViewForDevice pullViewForDevice;
@property (nonatomic, assign) NSInteger staint_index;
@property (nonatomic, weak) PPTrtcVideoView * first_stream_view;
@property (nonatomic, weak) PPTrtcVideoView * last_stream_view;
- (void)displayVideoViewForFit;
- (CGFloat)displayMarginLeftOrRight;
- (void)loginRoomId:(NSString * )roomId;
- (void)leaveRoom;
- (void)loadFirstStreamDefaultImageUrl:(NSString * )loadImageUrl;
- (void)loadLastStreamDefaultImageUrl:(NSString * )loadImageUrl;
- (void)switchGameVideo;
- (void)stopStream;
- (void)resume;
- (void)pause;
@end
NS_ASSUME_NONNULL_END
