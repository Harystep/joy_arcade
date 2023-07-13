#import <UIKit/UIKit.h>
#import "PPGameActionMoreModel.h"
#import "SJBaseGameViewController.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPGameMoreFunctionView : UIView
@property (nonatomic, strong) NSArray <PPGameActionMoreModel * > * btList;
@property (nonatomic, assign) SDGamePlayStatues playStatus;
@end
NS_ASSUME_NONNULL_END
