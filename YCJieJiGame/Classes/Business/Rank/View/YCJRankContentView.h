//
//  YCJRankContentView.h
//  YCJieJiGame
//
//  Created by zza on 2023/5/24.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJRankListModel;
@interface YCJRankContentView : YCJBaseView
- (void)setRankModel:(YCJRankListModel *)rankModel type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
