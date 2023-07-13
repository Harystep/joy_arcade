#import <UIKit/UIKit.h>
#import "PPTcpReceviceData.h"
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
  playAngin,
  playAppointment,
  sharedAction
} SDWawajiResultAction;
@interface PPWawajiResultViewController : UIViewController
@property (nonatomic, strong) PPTcpReceviceData * resultData;
@property (nonatomic, assign) BOOL isOtherPlay;
@property (nonatomic, strong) RACSubject * doneSubject;
@end
NS_ASSUME_NONNULL_END
