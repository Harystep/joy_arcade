

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCJAccountType) {
    YCJAccountTypeLogout,
    YCJAccountTypeCancellation
};

@interface YCJAccountLogoutAlertView : UIView

@property (nonatomic, copy) dispatch_block_t completed;
@property (nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property (nonatomic, assign) YCJAccountType type;
@property (nonatomic, strong) UILabel       *titleLB;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
