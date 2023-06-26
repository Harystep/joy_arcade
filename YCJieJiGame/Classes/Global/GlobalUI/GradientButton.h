//
//  GradientButton.h
//  YCJieJiGame
//
//  Created by John on 2023/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientButton : UIButton

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (void)setNormalBgColor;

- (void)setNormalBgColorWithColor:(UIColor *)color;

- (void)setNormalBgColorWithBorder;

- (void)setNormalBgColorWithBorderColor:(UIColor *)color;

- (void)setClearBgColor;

- (void)setClearBgColorWithBorderColor:(UIColor *)color;

- (void)setClearBgColorWithBorderColor:(UIColor *)color radius:(CGFloat)radius;

- (void)setGradientBgColor;

- (void)setGradientAlphaBgColor;

- (void)setGradientBlueBgColor;

- (void)setGradientBgColorWithBorder;

- (void)setGradientLayerColor:(UIColor *)color0 color:(UIColor *)color1;

@end

NS_ASSUME_NONNULL_END
