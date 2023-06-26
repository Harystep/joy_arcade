//
//  YCJRealNameAlertView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/22.
//

#import "YCJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJRealNameAlertView : YCJBaseViewController
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);

- (void)show:(YCJBaseViewController *)par;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
