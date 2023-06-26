//
//  YCJExchangeCoinsAlertView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/23.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
// 积分兑换金币
@class YCJExchangeModel;
@interface YCJExchangeCoinsAlertView : YCJBaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(YCJExchangeCoinsAlertView *, YCJExchangeModel *);
@property(nonatomic, strong) YCJExchangeModel *exchangeModel;
@property(nonatomic, strong) NSString *zuanshi;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
