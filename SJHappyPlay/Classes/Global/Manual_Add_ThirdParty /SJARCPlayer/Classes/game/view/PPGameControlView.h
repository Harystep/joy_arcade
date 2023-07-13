#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "PPGameStartButton.h"
#import "SDGameDefineHeader.h"
typedef enum : NSUInteger {
  sendMessage,
  recharge,
  playStartGame,
} SDGameControlAction;
NS_ASSUME_NONNULL_BEGIN
@interface PPGameControlView : UIView
@property (nonatomic, strong) NSString * gamePrice;
@property (nonatomic, assign) GameButtonStatus btStatus;
@property (nonatomic, assign) NSInteger appointmentCount;
@property (nonatomic, strong) RACSubject * gameDoneSubject;
@property (nonatomic, strong) RACSubject * longTouchActionSubject;
@property (nonatomic, strong) RACSubject * longTouchEndSubject;
@property (nonatomic, strong) RACSubject * catchActionSubject;
@property (nonatomic, assign) NSInteger countDownTime;
- (instancetype)initWithType:(SDGameType)type;
- (void)startToPlayGame;
- (void)definePlayGame;
- (void)defineOtherPlayGame;
- (void)appWillEnterForeground;
@end
NS_ASSUME_NONNULL_END
