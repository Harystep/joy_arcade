//
//  UIFont+SDFont.m
//  SDGameForwawajiUniPlugin
//
//  Created by sander shan on 2022/11/1.
//

#import "UIFont+SDFont.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEH_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation UIFont (SDFont)

+ (UIFont *)autoFontWithPX:(CGFloat)px{
    return [UIFont systemFontOfSize:[self newFont:px]];
}

+ (UIFont *)autoBoldFontWithPX:(CGFloat)px{
    //    return [UIFont boldSystemFontOfSize:[self newFont:px]];
    
    if (@available(ios 8.2, *)) {
        return [UIFont systemFontOfSize:[self newFont:px] weight:UIFontWeightBold];
    }else{
        return [UIFont boldSystemFontOfSize:[self newFont:px]];
    }
}
+ (UIFont *)autoMediumFontWithPX:(CGFloat)px{
    //    return [UIFont boldSystemFontOfSize:[self newFont:px]];
    
    if (@available(ios 8.2, *)) {
        return [UIFont systemFontOfSize:[self newFont:px] weight:UIFontWeightMedium];
    }else{
        return [UIFont boldSystemFontOfSize:[self newFont:px]];
    }
}

+ (CGFloat)newFont:(CGFloat)px{
    CGFloat f = px/2;
    CGFloat screenWidth = SCREEN_WIDTH < SCREEH_HEIGHT ? SCREEN_WIDTH : SCREEH_HEIGHT;
    if (screenWidth<375) {
        f-=2;
    }else if (screenWidth>375){
        f+=1;
    }
    return f;
}

@end

