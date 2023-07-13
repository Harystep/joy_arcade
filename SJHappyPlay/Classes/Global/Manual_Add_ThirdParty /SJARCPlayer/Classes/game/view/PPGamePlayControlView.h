#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPGamePlayControlView : UIView
@property (nonatomic, strong) RACSubject * longTouchActionSubject;
@property (nonatomic, strong) RACSubject * longTouchEndSubject;
@property (nonatomic, strong) RACSubject * catchActionSubject;
@property (nonatomic, assign) NSInteger countDownTime;
- (void)showCountDownInfo;
- (void)hideCounDownInfo;
- (void)startWawajiGame;
@end
NS_ASSUME_NONNULL_END
