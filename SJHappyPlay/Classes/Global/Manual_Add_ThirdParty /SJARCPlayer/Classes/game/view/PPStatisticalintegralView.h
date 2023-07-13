#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPStatisticalintegralView : UIView
@property (nonatomic, strong) RACSubject * offPlaneSubject;
@property (nonatomic, assign) NSInteger integralValue;
@property (nonatomic, assign) NSInteger type;
@end
NS_ASSUME_NONNULL_END
