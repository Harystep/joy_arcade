//
//  UIImage+Extras.h

//
//  Created by Aalto on 2018/12/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extras)

/// 根据颜色生成图片
+(UIImage *)imageWithColor:(UIColor *)color;
/// 根据颜色生成图片
/// @param color 颜色
/// @param rect 大小
+(UIImage *)imageWithColor:(UIColor *)color
                      rect:(CGRect)rect;
/// UIColor 转 UIImage
+(UIImage *)createImageWithColor:(UIColor *)color;
/// NSString 转 UIImage
/// @param string 准备转换的字符串
/// @param font 该字符串的字号
/// @param width 该字符串的线宽
/// @param textAlignment 字符串位置
/// @param backGroundColor 背景色
/// @param textColor 字体颜色
+(UIImage *)imageWithString:(NSString *)string
                       font:(UIFont *)font
                      width:(CGFloat)width
              textAlignment:(NSTextAlignment)textAlignment
            backGroundColor:(UIColor *)backGroundColor
                  textColor:(UIColor *)textColor;
/// NSString 转 UIImage
/// @param string 准备转换的字符串
/// @param size 字符串的尺寸
+(UIImage *)createNonInterpolatedUIImageFormString:(NSString *)string
                                          withSize:(CGFloat)size;
///根据字符串生成二维码
+(UIImage *)createRRcode:(NSString *)sourceString;

///更改图标颜色
+ (UIImage *)imageWithImageName:(NSString *)name imageColor:(UIColor *)imageColor;
-(UIImage*)imageChangeColor:(UIColor*)color;
+ (UIImage *)createImageWithColor:(UIColor*) color andSize:(CGSize)imageSize;
@end

NS_ASSUME_NONNULL_END
