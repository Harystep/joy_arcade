

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJRankListModel;
@interface YCJRankContentView : QABaseView
- (void)setRankModel:(YCJRankListModel *)rankModel type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
