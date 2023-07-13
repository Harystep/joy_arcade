#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
typedef enum : NSUInteger {
  goldLegendControl_pushCoin = 1, 
  goldLegendControl_fireDouble, 
  goldLegendControl_fireLock, 
  goldLegendControl_fireAuto, 
  goldLegendControl_fireSimple, 
} SDGOldLegendControlType;
NS_ASSUME_NONNULL_BEGIN
@interface PPGoldLegendControlView : UIView
@property (nonatomic, strong) RACSubject * simpleControlSubject;
@property (nonatomic, strong) RACSubject * controlLeftSubject;
@property (nonatomic, strong) RACSubject * controlRightSubject;
@end
NS_ASSUME_NONNULL_END
