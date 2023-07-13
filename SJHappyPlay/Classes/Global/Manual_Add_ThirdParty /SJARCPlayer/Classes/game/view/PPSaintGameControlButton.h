#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
typedef enum : NSUInteger {
  ControlTouchDown,
  ControlTouchUp,
  ControlTouchSimple,
} SDSaintGameControlActionType;
NS_ASSUME_NONNULL_BEGIN
@interface PPSaintGameControlButton : UIControl
@property (nonatomic, strong) RACSubject * touchSubject;
@property (nonatomic, weak) UIView * theControlBgView;
@property (nonatomic, strong) UIImage * actionLogoImage;
- (void)showSaintShootBt;
- (void)showSaintRaisebetBt;
- (void)showPushCoinBt;
@end
NS_ASSUME_NONNULL_END
