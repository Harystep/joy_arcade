#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPCountDownView : UIView
@property (nonatomic, assign) NSInteger maxCountDownTime;
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, strong) RACSubject * gameOverSubject;
- (void)startAnimation;
- (void)stopAnimation;
@end
NS_ASSUME_NONNULL_END
