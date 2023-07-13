#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPGameGoodDetailView : UIView
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, strong) NSArray * imgs;
@property (nonatomic, strong) RACSubject * theActionSubject;
- (void)changeTab:(NSInteger)tab;
@end
NS_ASSUME_NONNULL_END
