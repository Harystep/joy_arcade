

#import "QABaseView.h"
#import "YCJRankListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YCJRankTopView : QABaseView
@property(nonatomic, strong) YCJRankListModel *rankModel;
@property(nonatomic, strong) YCJRankListModel *caifuModel;
@end

NS_ASSUME_NONNULL_END
