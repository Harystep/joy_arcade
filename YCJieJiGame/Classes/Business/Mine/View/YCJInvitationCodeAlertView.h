//
//  YCJInvitationCodeAlertView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/22.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJInviteCodeModel;
@interface YCJInvitationCodeAlertView : YCJBaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property (nonatomic, strong) YCJInviteCodeModel        *inviteModel;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
