#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "PPSaintGameControlButton.h"

NS_ASSUME_NONNULL_BEGIN


@interface PPSaintPlayerControlView : UIView
@property (nonatomic, strong) RACSubject * longTouchActionSubject;
@property (nonatomic, strong) RACSubject * longTouchEndSubject;
@property (nonatomic, strong) RACSubject * simpleTouchSubject;

@property (nonatomic, strong) RACSubject * arcadeCoinSubject;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, weak) PPSaintGameControlButton * theFireButton;
@property (nonatomic, weak) PPSaintGameControlButton * theRaisebetButton;
@property (nonatomic, weak) PPSaintGameControlButton * thePushCoinButton;

- (void)endTouchAction;
@end
NS_ASSUME_NONNULL_END
