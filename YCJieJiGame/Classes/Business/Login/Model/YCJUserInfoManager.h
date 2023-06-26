//
//  YCJUserInfoManager.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YCJUserInfoModel,YCJBaseViewController, YCJToken;
@interface YCJUserInfoManager : NSObject

@property(nonatomic, strong) YCJUserInfoModel   *userInfoModel;
@property(nonatomic, strong) YCJToken           *userTokenModel;

+ (instancetype)sharedInstance;

- (void)reloadUserInfo;
- (void)deleteUserInfo;
/// 是否登录
- (BOOL)isLogin:(YCJBaseViewController *)control;
/// 是否登录
- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
