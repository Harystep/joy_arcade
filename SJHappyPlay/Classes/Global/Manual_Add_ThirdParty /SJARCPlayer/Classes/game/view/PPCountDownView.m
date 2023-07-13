#import "PPCountDownView.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "POP.h"

#import "AppDefineHeader.h"

@interface PPCountDownView ()
@property (nonatomic, strong) CAShapeLayer * theProcessLayer;
@property (nonatomic, weak) UILabel * theCountDownLabel;
@property (nonatomic, strong) NSTimer * countDownTimer;
@end
@implementation PPCountDownView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(130), SF_Float(130));
    [self configView];
    [self configData];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.width / 2.f];
  CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
  shapeLayer.path = path.CGPath;
  shapeLayer.strokeColor = [UIColor colorForHex:@"#FF2929"].CGColor;
  shapeLayer.lineWidth = SF_Float(8);
  shapeLayer.fillColor = [UIColor clearColor].CGColor;
  shapeLayer.strokeStart = 0;
  shapeLayer.strokeEnd = 0;
  shapeLayer.lineCap = @"round";
  [self.layer addSublayer:shapeLayer];
  self.theProcessLayer = shapeLayer;
}
- (void)configData {
  self.gameOverSubject = [RACSubject subject];
}
#pragma mark - set
- (void)setCountDownTime:(NSInteger)countDownTime {
  _countDownTime = countDownTime;
  self.theCountDownLabel.text = [NSString stringWithFormat:@"%lds", self.countDownTime];
}
#pragma mark - public method
- (void)startAnimation {
  self.theProcessLayer.strokeEnd = 1;
  CGFloat start_at = self.maxCountDownTime - self.countDownTime;
  CGFloat fromValue = start_at / self.maxCountDownTime;
  POPBasicAnimation * banimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
  banimation.fromValue = @(fromValue);
  banimation.toValue = @(1);
  banimation.duration = self.countDownTime;
  [self.theProcessLayer pop_addAnimation:banimation forKey:@"shapLayerStrokeStart"];
  if (self.countDownTimer) {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
  }
  [self.theCountDownLabel setHidden:false];
  self.countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onRepeartTimer) userInfo:nil repeats:true];
  [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
}
- (void)stopAnimation {
  [self.theProcessLayer pop_removeAnimationForKey:@"shapLayerStrokeStart"];
  [self.countDownTimer invalidate];
  self.countDownTimer = nil;
}
- (void)onRepeartTimer {
  self.countDownTime -= 1;
  if (self.countDownTime <= 0) {
    self.countDownTime = 0;
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [self.theCountDownLabel setHidden:true];
    [self.gameOverSubject sendNext:0];
  }
}
#pragma mark - lazy UI
- (UILabel * )theCountDownLabel{
  if (!_theCountDownLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    theView.textAlignment = NSTextAlignmentCenter;
      theView.font = AutoPxFont(34);
    theView.textColor = [UIColor whiteColor];
    [theView setHidden:true];
    _theCountDownLabel = theView;
  }
  return _theCountDownLabel;
}
@end
