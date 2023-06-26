//
//  YCJRankSelectedView.h
//  YCJieJiGame
//
//  Created by zza on 2023/6/20.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJRankSelectedView : YCJBaseView
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(NSInteger);
@end

NS_ASSUME_NONNULL_END
