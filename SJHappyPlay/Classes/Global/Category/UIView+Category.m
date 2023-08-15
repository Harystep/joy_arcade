//
//  UIView+Category.m
//  HJCommunity
//
//  Created by John on 2021/6/8.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

@implementation UIView (Category)

#pragma mark - setter
- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)max_X {
    return CGRectGetMaxX(self.frame);
}

- (void)setMax_X:(CGFloat)max_X {}

- (CGFloat)max_Y {
    return CGRectGetMaxY(self.frame);
}

- (void)setMax_Y:(CGFloat)max_Y {}

#pragma mark - getter
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)clipWithcornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(willMoveToSuperview:);
        SEL swizzSel = @selector(qcWillMoveToSuperview:);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)qcWillMoveToSuperview:(UIView *)newSuperview {
    [self qcWillMoveToSuperview:newSuperview];
    if(!newSuperview)return;
    if ([self isMemberOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        CGFloat fontSize = [self updateFontSizeWithSize:label.font.pointSize];
        label.font = [self updateFontWithFont:label.font size:fontSize];
    }else if([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        CGFloat fontSize = [self updateFontSizeWithSize:button.titleLabel.font.pointSize];
        button.titleLabel.font = [self updateFontWithFont:button.titleLabel.font size:fontSize];
    }else if([self isKindOfClass:[UITextField class]]) {
        UITextField *field = (UITextField *)self;
        CGFloat fontSize = [self updateFontSizeWithSize:field.font.pointSize];
        field.font = [self updateFontWithFont:field.font size:fontSize];
    }else if([self isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self;
        CGFloat fontSize = [self updateFontSizeWithSize:textView.font.pointSize];
        textView.font = [self updateFontWithFont:textView.font size:fontSize];
    }
}

- (UIFont *)updateFontWithFont:(UIFont *)font size:(float)size {
    if([font.fontName containsString:@"PingFangSC"])return font;
    if([font.fontName containsString:@"Semibold"]) {
        return [UIFont fontWithName:@"PingFangSC-Bold" size:size] ?: font;
    }else if([font.fontName containsString:@"Medium"]) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size] ?: font;
    }else {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size] ?: font;
    }
}

- (CGFloat)updateFontSizeWithSize:(CGFloat)size {
    if(kScreenWidth <= 320) {
        size *= 0.9;
    }else if(kScreenWidth <= 375) {
        size *= 1.0;
    }else {
        size *= 1.1;
    }
    return size;
}

//1.提供一个UIView的分类方法，这个方法通过响应者链条获取view所在的控制器
- (UIViewController *)parentController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


+ (UIImage *)gradient:(NSArray *)colors size:(CGSize)size {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.frame = CGRectMake(0,0,size.width,size.height);
    gradient.colors = colors;
    //2把渐变色生成为Image
    UIGraphicsBeginImageContextWithOptions(size, 1, 0.0);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //3设置view背景色
    return img;
}

- (UILabel *)createSimpleLabelWithTitle:(NSString *)title font:(CGFloat)font bold:(BOOL)bold  color:(UIColor *)color {
    UILabel *lb = [[UILabel alloc] init];
    if (title != nil) {
        lb.text = title;
    }
    lb.textColor = color;
    if (bold) {
        lb.font = kPingFangSemiboldFont(font);
    } else {
        lb.font = kPingFangRegularFont(font);
    }
    return lb;
}

- (void)setViewColorAlpha:(CGFloat)alpha color:(UIColor *)color {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = color;
    bgView.alpha = alpha;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIButton *)createSimpleButtonWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    UIButton *bt = [[UIButton alloc] init];
    if (title != nil) {
        [bt setTitle:title forState:UIControlStateNormal];
    }
    [bt setTitleColor:color forState:UIControlStateNormal];
    bt.titleLabel.font = kPingFangRegularFont(font);
    return bt;
}

- (UITextField *)createTextFieldOnTargetView:(UIView *)targetView withFrame:(CGRect)rect withPlaceholder:(NSString *)placeholder {
    UITextField *textF = [[UITextField alloc] init];
    textF.frame = rect;
    [targetView addSubview:textF];
    textF.placeholder = placeholder;
    return textF;
}

- (void)setViewCornerRadiu:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setViewBorderWithColor:(CGFloat)bordWidth color:(UIColor *)color {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = bordWidth;
}

@end
