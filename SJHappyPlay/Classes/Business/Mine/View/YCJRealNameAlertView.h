

#import "QABaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJRealNameAlertView : QABaseViewController
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);

- (void)show:(QABaseViewController *)par;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
