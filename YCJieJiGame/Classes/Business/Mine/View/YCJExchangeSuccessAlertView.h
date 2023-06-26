//
//  YCJExchangeSuccessAlertView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/23.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
// 兑换成功
@interface YCJExchangeSuccessAlertView : YCJBaseView

@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
