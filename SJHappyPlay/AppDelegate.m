
#import "AppDelegate.h"
#import "QATabBarController.h"
#import "SJLaunchViewController.h"
#import "SJHappyPlay-Swift.h"
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupAppearance];
    SJLaunchViewController *vc = [[SJLaunchViewController alloc] init];
    vc.completed = ^{
        WeakSelf
        weakSelf.window.rootViewController = [[QATabBarController alloc] init];
    };
    self.window.rootViewController = vc;
//    if (@available(iOS 13.0, *)) {
//        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
//    }
    [self.window makeKeyAndVisible];
    
    [[IAPHelper shared] setupIAP];
    
    [self setup3DTouchItems:application];
    
    [self configureUmengSDK];
    
    return YES;
}

- (void)configureUmengSDK {
    [UMConfigure initWithAppkey:@"649ba83ea1a164591b3ccfc4" channel:nil];
    [UMConfigure setLogEnabled:YES];
}

- (void)setupAppearance {
    //默认为YES
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;

    /**
     *  设置 ATAuthSDK 的秘钥信息
     *  建议该信息维护在自己服务器端
     *  放在程序入口处调用效果最佳
     *
     *  1. 首先会从本地沙盒中找
     *  2. 沙盒找不到使用本地最初的秘钥进行初始化
     *  3. 同时发送异步请求从服务端拉取最新秘钥，拉取成功更新到本地沙盒中
     */
    NSString *authSDKInfo = [[NSUserDefaults standardUserDefaults] objectForKey:PNSATAUTHSDKINFOKEY];
    if (!authSDKInfo || authSDKInfo.length == 0) {
        authSDKInfo = PNSATAUTHSDKINFO;
    }
    /// 建议该信息维护在自己服务器端
//    [JKNetWorkManager getRequestWithUrlPath:@"aliyunSdkKeyUrl" parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
//        if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
//            NSString *authSDKInfo = result.resultData[@"sdkInfo"];
//            [[NSUserDefaults standardUserDefaults] setObject:authSDKInfo forKey:PNSATAUTHSDKINFOKEY];
//        }
//    }];

    [[TXCommonHandler sharedInstance] setAuthSDKInfo:authSDKInfo
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"设置秘钥结果：%@", resultDic);
    }];
}

- (void)setup3DTouchItems:(UIApplication *)application {
    UIApplicationShortcutIcon *searchIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
    UIApplicationShortcutItem *searchItem = [[UIApplicationShortcutItem alloc]initWithType:@"GAME" localizedTitle:ZCLocalizedString(@"游戏", nil) localizedSubtitle:nil icon:searchIcon userInfo:nil];
    
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc]initWithType:@"SHARE" localizedTitle:ZCLocalizedString(@"分享", nil) localizedSubtitle:nil icon:shareIcon userInfo:nil];
    application.shortcutItems = @[searchItem, shareItem];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
    if([shortcutItem.type isEqualToString:@"SHARE"]) {//分享
        
    } else if ([shortcutItem.type isEqualToString:@"GAME"]) {//
        self.window.rootViewController = [[QATabBarController alloc] init];
        [self.window makeKeyAndVisible];
    }
}

@end
