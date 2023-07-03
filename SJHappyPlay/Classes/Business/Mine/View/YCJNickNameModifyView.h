

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJNickNameModifyView : QABaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
