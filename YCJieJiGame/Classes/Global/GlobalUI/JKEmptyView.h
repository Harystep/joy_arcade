//
//  JKEmptyView.h
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JKEmptyViewActionBlock)(void);

@interface JKEmptyView : UIView


- (void)setupText:(NSString *)text;
- (void)setupText:(NSString *)text image:(UIImage *)image;
- (void)setupText:(NSString *)text image:(UIImage *)image actionTitle:(NSString *)actionTitle action:(JKEmptyViewActionBlock)action;
- (void)setEmptyBgColor:(UIColor *)backgroundColor;
- (void)setContentBgViewColor:(UIColor *)backgroundColor;
- (void)setTextColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END
