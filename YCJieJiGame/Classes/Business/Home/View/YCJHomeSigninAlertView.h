//
//  YCJHomeSigninAlertView.h
//  YCJieJiGame
//
//  Created by zza on 2023/5/25.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJSignInListModel;
@interface YCJHomeSigninAlertView : YCJBaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property (nonatomic, strong) YCJSignInListModel *listModel;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
