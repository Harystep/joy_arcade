

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SKUserInfoModel,QABaseViewController, YCJToken;
@interface SKUserInfoManager : NSObject

@property(nonatomic, strong) SKUserInfoModel   *userInfoModel;
@property(nonatomic, strong) YCJToken           *userTokenModel;

+ (instancetype)sharedInstance;

- (void)reloadUserInfo;
- (void)deleteUserInfo;
/// 是否登录
- (BOOL)isLogin:(QABaseViewController *)control;
/// 是否登录
- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
