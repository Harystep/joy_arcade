

#import "SKUserInfoManager.h"
#import "SKUserInfoModel.h"
#import "QABaseViewController.h"
#import "SKLoginViewController.h"

@implementation SKUserInfoManager

+ (void)load {
    [[SKUserInfoManager sharedInstance] readUserInfo];
}

+ (instancetype)sharedInstance {
    static SKUserInfoManager * ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}


+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}

#pragma mark —— lazyLoad

- (void)setUserTokenModel:(YCJToken *)userTokenModel {
    _userTokenModel = userTokenModel;
    if(_userTokenModel) {
        [self saveTokenInfo];
    }else {
        [self deleteUserInfo];
    }
}

- (void)setUserInfoModel:(SKUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    if(userInfoModel) {
        [self saveUserInfo];
    }else {
        [self deleteUserInfo];
    }
}

- (BOOL)isLogin:(QABaseViewController *)control {
    if (self.isLogin) {
        return self.isLogin;
    } else {
        SKLoginViewController *vc = [[SKLoginViewController alloc] init];
        [control.navigationController pushViewController:vc animated:YES];
        return NO;
    }
}

- (BOOL)isLogin {
    return self.userInfoModel && self.userTokenModel.accessToken.length > 0;
}

static NSString *userDataKey = @"userDataKey";
static NSString *userTokenKey = @"userTokenKey";
- (void)saveUserInfo {
    if(!self.userInfoModel)return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userInfoModel.mj_keyValues forKey:userDataKey];
    [defaults synchronize];
    [self updateUser];
}

- (void)saveTokenInfo {
    if(!self.userTokenModel)return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userTokenModel.mj_keyValues forKey:userTokenKey];
    [defaults synchronize];
}

- (void)deleteUserInfo {
    _userInfoModel = nil;
    _userTokenModel = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:userDataKey];
    [defaults removeObjectForKey:userTokenKey];
    [defaults synchronize];
    [self updateUser];
}

- (void)readUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tokenDict = [defaults objectForKey:userTokenKey];
    if(!tokenDict)return;
    self.userTokenModel = [YCJToken mj_objectWithKeyValues:tokenDict];
    NSDictionary *userDict = [defaults objectForKey:userDataKey];
    if(!userDict)return;
    self.userInfoModel = [SKUserInfoModel mj_objectWithKeyValues:userDict];
}

- (void)reloadUserInfo {
    if (self.isLogin) {
        [JKNetWorkManager getRequestWithUrlPath:JKHuiyuanDetailUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
            WeakSelf
            if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
                [SKUserInfoManager sharedInstance].userInfoModel = [SKUserInfoModel mj_objectWithKeyValues:result.resultData];
                [weakSelf updateUser];
            }
        }];
    } else {
        [self updateUser];
    }
    
}

- (void)updateUser {
    [[NSNotificationCenter defaultCenter] postNotificationName:YCJUserInfoModiyNotification object:nil];
}

@end
