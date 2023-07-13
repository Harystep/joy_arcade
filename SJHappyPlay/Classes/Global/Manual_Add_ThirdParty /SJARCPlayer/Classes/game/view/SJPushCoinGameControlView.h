#import <UIKit/UIKit.h>
#import "PPGameStartButton.h"
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface SJPushCoinGameControlView : UIView
@property (nonatomic, strong) NSString * gamePrice;
@property (nonatomic, assign) GameButtonStatus btStatus;
@property (nonatomic, assign) NSInteger appointmentCount;
@property (nonatomic, strong) RACSubject * gameDoneSubject;
@property (nonatomic, strong) RACSubject * pushCoinSubject;
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, assign) NSInteger maxCountDownTime;
- (void)startToPlayGame;
- (void)definePlayGame;
- (void)startCountDownTimer;
- (void)defineOtherPlayGame;
- (void)stopCountDownTimer;
@end
NS_ASSUME_NONNULL_END
