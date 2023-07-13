#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
  startAction, 
  appointmentAction, 
  cancelAppointmentAction, 
  selfGamingAction, 
} GameButtonStatus;
@interface PPGameStartButton : UIControl
@property (nonatomic, strong) UIImage * startGameImage;
@property (nonatomic, strong) UIImage * appointmentImage;
@property (nonatomic, strong) UIImage * cancelAppointmentImage;
@property (nonatomic, assign) GameButtonStatus btStatus;
@property (nonatomic, strong) NSString * gamePrice;
@property (nonatomic, assign) NSInteger appointmentCount;
- (void)showAppointmentInfo;
@end
NS_ASSUME_NONNULL_END
