

#import "QABaseView.h"
#import "SKUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 个人中心头部视图
@interface YCJMineHeaderView : QABaseView
- (instancetype)initWithFrame:(CGRect)frame;

/// 登录回调
@property(nonatomic, copy) void (^mineHeaderViewLoginClickBlock)(void);
/// 头像点击回调
@property(nonatomic, copy) void (^mineHeaderViewHeadImageClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
