

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JKEmptyView;


@interface QABaseViewController : UIViewController

///导航栏隐藏
@property (nonatomic, assign) BOOL setupNavigationBarHidden;
///状态栏隐藏
@property (nonatomic, assign) BOOL statusBarHidden;

- (void)setupEmptyViewWithText:(NSString *)text isEmpty:(BOOL)isEmpty action:(void(^)(void))action;
- (void)setupEmptyViewWithText:(NSString *)text imageName:(NSString *)name isEmpty:(BOOL)isEmpty action:(void(^)(void))action;
- (void)setupEmptyViewInView:(UIView *)view text:(NSString *)text isEmpty:(BOOL)isEmpty action:(void(^)(void))action;

@property (nonatomic, assign) CGFloat emptyViewTopOffset;
@property (nonatomic, strong) UIColor *emptyViewBgColor;
@property (nonatomic, strong) UIColor *emptyContentViewBgColor;
@property (nonatomic, strong) UIColor *emptyTextColor;
@property (nonatomic, strong) UIImageView *bgImageOne;

- (void)networkChange:(BOOL)net;
/// 输入gif全名，带后缀
- (void)bgimageGif:(NSString *)named;
- (void)bgImageName:(NSString *)named;
- (void)bgImageWhite;

- (void)removeEmptyView;

/// 返回按钮事件
- (void)goBackAction;

@end

NS_ASSUME_NONNULL_END
