//
//  UIView+Category.h
//  HJCommunity
//
//  Created by John on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat max_X;
@property (nonatomic, assign) CGFloat max_Y;

- (void)clipWithcornerRadius:(CGFloat)cornerRadius;

/** 这个方法通过响应者链条获取view所在的控制器 */
- (UIViewController *)parentController;

+ (UIImage *)gradient:(NSArray *)colors size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
