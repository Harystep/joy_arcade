#import "PPOutlineLabel.h"
@implementation PPOutlineLabel
- (void)drawTextInRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(c, 2.0f);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.outLinetextColor?self.outLinetextColor:[UIColor blackColor];
    [super drawTextInRect:rect];
    self.textColor = self.labelTextColor;
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}
- (UIColor * )labelTextColor{
    if (!_labelTextColor) {
        _labelTextColor = [UIColor whiteColor];
    }
    return _labelTextColor;
}
@end
