#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPWawajiNavigationHeaderView : UIView
@property (nonatomic, strong, readonly) RACSubject * backSubject;
@property (nonatomic, weak) UIButton * theBackButton;
@property (nonatomic, copy) NSString * title;

@end
NS_ASSUME_NONNULL_END
