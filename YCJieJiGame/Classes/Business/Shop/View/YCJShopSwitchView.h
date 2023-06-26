//
//  YCJShopSwitchView.h
//  YCJieJiGame
//
//  Created by John on 2023/5/31.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJShopSwitchView : YCJBaseView
@property(nonatomic, copy) void (^switchClickBlock)(NSInteger);
@end

NS_ASSUME_NONNULL_END
