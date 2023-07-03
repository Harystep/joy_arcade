

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJSignInListModel;
@interface YCJHomeSigninAlertView : QABaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property(nonatomic, copy) void (^jumpLoginBlock)(void);
@property (nonatomic, strong) YCJSignInListModel *listModel;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
