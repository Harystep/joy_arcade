//
//  NSString+YBCodec.h
//  Aa
//
//  Created by Aalto on 2018/11/20.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CalcLabelHeight_Width) {
    CalcLabelHeight = 0,
    CalcLabelWidth
};

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extras)

- (NSString *)md5;

//手机号脱敏显示，前三位和后两位正常显示，其他用*代替，比如185******88
+ (NSString *)secrectMobileString:(NSString *)mobile;

+ (BOOL)accurateIDCardWithFifteenOrEighteen:(NSString *)string;

- (NSAttributedString *)highlights:(NSArray *)keyWords highlightColor:(UIColor *)color;

+(NSString *)test:(NSArray <NSString *>*)arr;
/**
*  判断对象 / 数组是否为空
*  为空返回 YES
*  不为空返回 NO
*/
+(BOOL)isNullString:(NSString *)string;
#pragma mark —— 字符串替换
/**
*  有时候我们加载的URL中可能会出现中文,需要我们手动进行转码,但是同时又要保证URL中的特殊字符保持不变,那么我们就可以使用下面的方法
*/
+(NSURL *)Url_Chinese:(NSString *)urlStr;
//替换相关的字符为暂位符 example
+(NSString *)numberSuitScanf:(NSString*)number;
//我自己写的,服务器请求的数据为空值的时候进行替换本地默认值，因为json传输是通过对象包装来进行，所以其实归结起来就是2类，一类是基本数据类型被包装成Number、其他包装成String
+(NSString *)ensureNonnullString:(id)nullableStr
                      ReplaceStr:(NSString *)replaceStr;
#pragma mark —— 转化
//编码emoji
+(NSString *)emojiEncodeStr:(NSString *)str;
//解码emoji
+(NSString *)emojiDecodeStr:(NSString *)str;
// 读取本地JSON文件
+(NSDictionary *)readLocalFileWithName:(NSString *)name;
//JSON 转 NSDictionary
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
// NSDictionary 转 json字符串方法//==[dic mj_JSONString]
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//NSDictionary 转 NSString
+ (NSString *)convertDictionaryToString:(NSMutableDictionary *)dict;
// 判断是否为纯整数
+(BOOL)judgeiphoneNumberInt:(NSString *)number;
//字符串中取数字
+(long long)getDigitsFromStr:(NSString *)str;
//是否包含空格
+(BOOL)isHaveWhiteSpace:(NSString *)text;
/// 给定某字符串，判断里面的组成char是否全部为某个char
/// @param originString 被判定的字符串
/// @param standardChar 需要被检出的标准
+ (BOOL)isAllSameCharInString:(NSString *)originString
                 standardChar:(char)standardChar;
/// 根据字符串以及其对应的行宽（行高）、行高和字体字号，计算该文本占用的高度（宽度）
/// @param lineSpacing 行与行之间的间距
/// @param calcLabelHeight_Width 计算的结论是宽或者高
/// @param effectString 影响的字符串
/// @param font 该字符串的字号和字体
/// @param Height_Width  文本的宽度
+(CGFloat)getContentHeightOrWidthWithParagraphStyleLineSpacing:(CGFloat)lineSpacing
                                         calcLabelHeight_Width:(CalcLabelHeight_Width)calcLabelHeight_Width
                                                  effectString:(NSString *_Nonnull)effectString
                                                          font:(UIFont *_Nullable)font
                                  boundingRectWithHeight_Width:(CGFloat)Height_Width;

//数值过万用万做单位
+ (NSString *)getDealNumwithstring:(NSString *)string;

//获取字符串宽度
+ (CGFloat)getWidthWithStr:(NSString *)text height:(CGFloat)height titleFont:(UIFont *)font;

+ (BOOL)isPhoneNumber:(NSString *)number;

+ (BOOL)isAccount:(NSString *)text;

+ (BOOL)isPassword:(NSString *)text;

+ (BOOL)isContact:(NSString *)text;

/// 单位转换
+ (NSString *)unitsConverter:(NSString *)countStr;

+ (NSString *)convertImageNameWithLanguage:(NSString *)imageName;

+ (NSString *)stringConvertSafeContent:(id)content;

+ (NSMutableAttributedString *)setAttributeStringContent:(NSString *)text space:(CGFloat)space font:(UIFont *)font alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
