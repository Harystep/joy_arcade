#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPWawajiDetailViewController : UIViewController
@property (nonatomic, strong) NSArray * imgs;
@property (nonatomic, strong) RACSubject * theActionSubject;
- (void)showView;
@end
NS_ASSUME_NONNULL_END
