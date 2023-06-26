//
//  JKTools.h
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ifaddrs.h>    //获取Ip
#import <arpa/inet.h>
#import <net/if.h>


NS_ASSUME_NONNULL_BEGIN

@interface JKTools : NSObject


// 时间戳 转 特定格式 日期字符串
+ (NSString *)timeStampToString:(NSString *)timeStamp dateFormat:(NSString *)dateFormat;
// 时间 转 特定格式 日期字符串
+ (NSString *)dateStringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

// 过滤字符串，<null>、(null)、nil
+ (NSString *)handelString:(NSString *)string;

+ (NSString *)amountFormatter:(NSString *)amount;
+ (NSString *)discountFormatter:(NSString *)discount;

+ (NSMutableAttributedString *)attributeWithText:(NSString *)text attrText:(NSString *)attrText attributes:(NSDictionary *)attributes;
// 获取16位随机字符串
+ (NSString *)getRandomString;
//  对字符串进行MD5加密
+ (NSString *)md5:(NSString *)string;

+ (NSString *)idfv;

+ (NSString *)iphoneModel;

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (void)addSensorsAnalytics:(NSString *)event properties:(NSDictionary *)properties;
// 富文本字符串
+ (NSAttributedString *)attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts
                                lineSpacing:(CGFloat)l_spacing;

+ (NSAttributedString *)formatterAmount:(NSString *)amountText fontSize:(CGFloat)fontSize;


/**

 是否为空字符串（如果 == nil或者字符串长度小于1或者对象是 null都会判定为空字符串）
 
 @param string 需要判断字符串
 @return YES：空字符串  NO非空字符串
 */
+ (BOOL)isEmptyString:(NSString *)string;



+ (NSDictionary *)parametersWithUrl:(NSString *)url;


/**
 *  获取十六进制颜色
 *
 *  @param hexColor 十六进制
 *  @param alpha    透明度
 *
 *  @return color
 */
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

/*
 control 是要设置渐变字体的控件   bgVIew是control的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/// 写入文件  以数组的形式
+ (void)writeToFileWithDataArr:(NSArray *)dataArr fileName:(NSString *)fileName;
/// 根据文件名取出文件 返回数组
+ (NSArray *)readDataArrFromFileName:(NSString *)fileName;


///  字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


///获取基本后台地址
+ (NSString *)getBaseUrl;
///获取Web地址
+ (NSString *)getWebUrl;


+ (UIViewController *)topViewController;


// 判断是否是纯数字
+ (BOOL)checkIsNumText:(NSString *)str;

//加密 DES
+ (NSString *)encryptByDES:(NSString *)textStr key:(NSString *)key;
//解密 DES
+ (NSString *)decryptByDES:(NSString *)textStr key:(NSString *)key;



@end

NS_ASSUME_NONNULL_END
