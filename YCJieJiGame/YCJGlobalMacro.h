//
//  YCJGlobalMacro.h
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#ifndef YCJGlobalMacro_h
#define YCJGlobalMacro_h

#define ZCLocalizedString(key, comment) [SJLocalTool convertLanguageContent:key]
/// 尺寸
#define kScreenSize [UIScreen mainScreen].bounds.size
///屏幕宽
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
///屏幕高
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kScreen_Width6 375.0

///缩放比例 以iPhone6为参考
#define kWidthRatio  MIN(kScreenWidth, kScreenHeight) / kScreen_Width6
/// iPhoneX 系列
#define kIsIphoneX ((int)(kScreenHeight/kScreenWidth * 100) == 216)

///状态栏高度 （ 判断状态栏是否隐藏 ）
#define kStatusBarHeight ( ( ![[UIApplication sharedApplication] isStatusBarHidden] ) ? [[UIApplication sharedApplication] statusBarFrame].size.height : (kIsIphoneX ? 44.f:20.f))

///导航栏高度
#define kNaviBarHeight [UINavigationController new].navigationBar.frame.size.height

/// 状态栏加导航栏高度
#define kStatusBarPlusNaviBarHeight (kIsIphoneX ? 88 : 64)

/// 底部Tabbar高度 包含安全区域
#define kTabBarHeight (kIsIphoneX ? 83 : 49)

#define kSafeAreaBottomHeight (kIsIphoneX ? 34.0f : 0.0f)

#define kUserLoginSuckey @"kUserLoginSuckey"

/// 以iphone6 为比例
#define kSize(value)     round((1.0 * (value) * kWidthRatio))
/// 系统版本
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
/// App 名字
#define kAppName [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]
/// App 版本号
#define kAppVersion [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]
/// App 渠道
#define kAppChannel @"AppStore"
/// App 渠道
#define kAppChannelDebug @"AppStore_Debug"

#define kCategoryTitleViewHeight kSize(40)

/// 颜色
#define kColorRGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kColorRGB(R, G, B) kColorRGBA(R, G, B, 1.0)

#define kColorHexA(rgbValue, A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:A]

#define kColorHex(rgbValue) kColorHexA(rgbValue, 1.0)


///主题颜色
#define kThemeColor kColorHex(0xFDAC00)

///按钮主题颜色
#define kButtonThemeColor kColorHex(0x6984EA)

/// 横线颜色
#define kLineColor kColorRGBA(242,242,242,1.0)

/// 白色
#define kCommonWhiteColor kColorHex(0xFFFFFF)

/// 通用黑色
#define kCommonBlackColor kColorHex(0x333333)
/// 浅色
#define kLightBlackColor kColorHex(0x666666)
/// 更浅色黑色
#define kShallowBlackColor kColorHex(0x999999)




#define kPPGameChannelKey @"jiejidianwancheng"

#define kPPGameBaseRequestUrl @"https://jjdwc-api.5iwanquan.com/api/"

#define kPPGameBaseMyHost @"123.60.149.177"

#define kPPGameBaseMyPort @"56792"


#define kCustomerServiceBaseUrl @"http://kefu.51sssd.com/chat/mobile?"






///通用错误提示
#define kCommonError @"网络开小差了，请检查网络设置"

#define kAPPDelegate [[UIApplication sharedApplication] delegate]

/// 边距
#define kMargin kSize(15)

//0.5高度的线 masonry用
#define kLine_Height    (1.0/[UIScreen mainScreen].scale)


// PingFangSC
#define kPingFangLightFont(value)    [UIFont fontWithName:@"PingFangSC-Light" size:value]
#define kPingFangRegularFont(value)  [UIFont fontWithName:@"PingFangSC-Regular" size:value]
#define kPingFangMediumFont(value)   [UIFont fontWithName:@"PingFangSC-Medium" size:value]
#define kPingFangSemiboldFont(value) [UIFont fontWithName:@"PingFangSC-Semibold" size:value]
#define kSFUDINMitAltFont(value) [UIFont fontWithName:@"SFUDINMitAlt" size:value]


#define kReuseIdentifier NSStringFromClass ([self class])


/// 引用
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(self) strongSelf = weakSelf;


// 在主线程延迟若干秒执行block
NS_INLINE void kRunAfter(NSTimeInterval time,dispatch_block_t x){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(), x);
}

/// 消除警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/// 打印
#ifdef DEBUG
#define kLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__);
#else
#define kLog(...)
#define NSLog(...)
#endif

#endif /* YCJGlobalMacro_h */
