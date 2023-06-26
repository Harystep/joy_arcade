//
//  YCJRankTopView.h
//  YCJieJiGame
//
//  Created by zza on 2023/5/24.
//

#import "YCJBaseView.h"
#import "YCJRankListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YCJRankTopView : YCJBaseView
@property(nonatomic, strong) YCJRankListModel *rankModel;
@property(nonatomic, strong) YCJRankListModel *caifuModel;
@end

NS_ASSUME_NONNULL_END
