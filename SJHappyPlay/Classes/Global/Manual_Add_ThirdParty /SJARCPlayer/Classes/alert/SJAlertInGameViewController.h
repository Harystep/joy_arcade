#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
typedef enum : NSUInteger {
  SDAlertTypeCancel,
  SDAlertTypeSure,
} SDAlertType;
NS_ASSUME_NONNULL_BEGIN
@interface SJAlertInGameViewController : UIViewController
@property (nonatomic, strong) RACSubject * alertDoneSubject;
@property (nonatomic, assign) BOOL dismissCloseButton;
@property (nonatomic, assign) BOOL dismissSureButton;
- (void)showAlertInViewController:(UIViewController * )viewController;
- (void)insertAlertContentView:(UIView * )view;
@end
NS_ASSUME_NONNULL_END

