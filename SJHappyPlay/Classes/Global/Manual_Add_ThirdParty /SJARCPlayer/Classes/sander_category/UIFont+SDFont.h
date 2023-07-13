//
//  UIFont+SDFont.h
//  SDGameForwawajiUniPlugin
//
//  Created by sander shan on 2022/11/1.
//
#import <UIKit/UIKit.h>

@interface UIFont (SDFont)

+ (UIFont *)autoFontWithPX:(CGFloat)px;

+ (UIFont *)autoBoldFontWithPX:(CGFloat)px;

+ (UIFont *)autoMediumFontWithPX:(CGFloat)px;


+ (CGFloat)newFont:(CGFloat)px;

@end
