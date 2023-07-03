

#import "GradientButton.h"

@implementation GradientButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gradientLayer.frame = self.bounds;
    }
    return self;
}


- (void)setGradientBgColor{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clickLayer];
    self.alpha = 1.0;
}

- (void)setGradientAlphaBgColor{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clickLayer];
    self.alpha = 0.5;
}

- (void)setGradientBlueBgColor{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clickBlueLayer];
    self.alpha = 1.0;
}

- (void)setNormalBgColor{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self normalLayer];
    self.alpha = 1.0;
}

- (void)setNormalBgColorWithColor:(UIColor *)color{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self normalLayerWithColor:color color:color];
    self.alpha = 1.0;
}

- (void)setGradientLayerColor:(UIColor *)color0 color:(UIColor *)color1{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self normalLayerWithColor:color0 color:color1];
    self.alpha = 1.0;
}

- (void)setGradientBgColorWithBorder{
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clickLayer];
    [self.layer setBorderColor:[kCommonWhiteColor CGColor]];
    [self.layer setBorderWidth:0.5];
    self.alpha = 1.0;
}

- (void)setNormalBgColorWithBorder{
    [self setNormalBgColorWithBorderColor:kCommonWhiteColor];
}

- (void)setNormalBgColorWithBorderColor:(UIColor *)color{
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clearLayer];
    [self.layer setBorderColor:[color CGColor]];
    [self.layer setBorderWidth:0.5];
}

- (void)setClearBgColor{
    [self.layer setBorderWidth:0];
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clearLayer];
}

- (void)setClearBgColorWithBorderColor:(UIColor *)color{
    [self setClearBgColorWithBorderColor:color radius:0];
}

- (void)setClearBgColorWithBorderColor:(UIColor *)color radius:(CGFloat)radius{
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [self clearLayer];
    [self.layer setBorderColor:[color CGColor]];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderWidth:0.5];
    self.alpha = 1.0;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [self clickLayer];
        _gradientLayer = gradientLayer;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

- (CAGradientLayer *)clickLayer{
    CAGradientLayer *clickLayer = [CAGradientLayer layer];
    clickLayer.frame = self.bounds;
    clickLayer.startPoint = CGPointMake(0, 0);
    clickLayer.endPoint = CGPointMake(1, 0);
    [clickLayer setColors:@[(id)kColorHex(0xFFFFFF).CGColor,(id)kColorHex(0xFAE035).CGColor, (id)kColorHex(0xDD9C42).CGColor]];//渐变数组
    return clickLayer;
}

- (CAGradientLayer *)clickBlueLayer{
    CAGradientLayer *clickBlueLayer = [CAGradientLayer layer];
    clickBlueLayer.frame = self.bounds;
    clickBlueLayer.startPoint = CGPointMake(0, 0);
    clickBlueLayer.endPoint = CGPointMake(1, 0);
    [clickBlueLayer setColors:@[(id)kColorHex(0xFFFFFF).CGColor,(id)kColorHex(0xFAE035).CGColor, (id)kColorHex(0xDD9C42).CGColor]];//渐变数组
    return clickBlueLayer;
}

- (CAGradientLayer *)normalLayer{
    CAGradientLayer *normalLayer = [CAGradientLayer layer];
    normalLayer.frame = self.bounds;
    normalLayer.startPoint = CGPointMake(0, 0);
    normalLayer.endPoint = CGPointMake(1, 0);
    [normalLayer setColors:@[(id)[[UIColor redColor] CGColor], (id)[[UIColor clearColor] CGColor]]];//渐变数组
    return normalLayer;
}

- (CAGradientLayer *)normalLayerWithColor:(UIColor *)color0 color:(UIColor *)color1{
    CAGradientLayer *normalLayer = [CAGradientLayer layer];
    normalLayer.frame = self.bounds;
    normalLayer.startPoint = CGPointMake(0, 0);
    normalLayer.endPoint = CGPointMake(1, 0);
    [normalLayer setColors:@[(id)[color0 CGColor], (id)[color1 CGColor]]];//渐变数组
    return normalLayer;
}

- (CAGradientLayer *)clearLayer{
    CAGradientLayer *clearLayer = [CAGradientLayer layer];
    clearLayer.frame = self.bounds;
    clearLayer.startPoint = CGPointMake(0, 0);
    clearLayer.endPoint = CGPointMake(1, 0);
    [clearLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[[UIColor clearColor] CGColor]]];//渐变数组
    return clearLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

@end
