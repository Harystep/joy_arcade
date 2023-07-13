#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPRecentlyCateLogViewController : UIViewController
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, strong) RACSubject * theActionSubject;
- (void)showView;
@end
NS_ASSUME_NONNULL_END
