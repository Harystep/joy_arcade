

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJInviteCodeModel;
@interface YCJInvitationCodeAlertView : QABaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property (nonatomic, strong) YCJInviteCodeModel        *inviteModel;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
