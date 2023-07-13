#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
typedef enum : NSUInteger {
  gameActionCoin,
  gameActionCharge,
  gameActionCharter,
  gameActionLockMachine,
  gameActionCustomService,
  gameActionSetting,
  gameActionRule,
  gameActionCriticalMachine,
  gameActionSettlement,
  gameActionExit,
  gameActionExchagne,
} SDGameActionType;
NS_ASSUME_NONNULL_BEGIN
@interface PPGameActionMoreModel : NSObject
@property (nonatomic, strong) UIImage * buttonImage;
@property (nonatomic, strong) UIImage * disableButtonImage;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, strong) RACSubject * doneSubject;
@property (nonatomic, assign) SDGameActionType actionType;
- (instancetype)initWithActionType:(SDGameActionType)type;
@end
NS_ASSUME_NONNULL_END
