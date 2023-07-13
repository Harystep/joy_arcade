#import "PPStartGameLoadingView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "POP.h"
#import "PPImageUtil.h"
#import "AppDefineHeader.h"

@interface PPStartGameLoadingView ()
@property (nonatomic, weak) UIImageView * theCenterAnimationView;
@end
@implementation PPStartGameLoadingView
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self theCenterAnimationView];
}
#pragma mark - public method
- (void)startLoadingAnimation {
  [self showCenterAnimationViewWithIndex:3];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.666 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self showCenterAnimationViewWithIndex:2];
  });
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.333 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self showCenterAnimationViewWithIndex:1];
  });
}
- (void)showCenterAnimationViewWithIndex:(NSInteger) index {
  if (index == 3) {
    self.theCenterAnimationView.image = [PPImageUtil imageNamed:@"ico_game_3"];
  } else if (index == 2) {
    self.theCenterAnimationView.image = [PPImageUtil imageNamed:@"ico_game_2"];
  } else if (index == 1) {
    self.theCenterAnimationView.image = [PPImageUtil imageNamed:@"ico_game_1"];
  }
  POPBasicAnimation * animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
  animation1.fromValue = @(0);
  animation1.toValue = @(1);
  animation1.duration = 0.333;
  [self.theCenterAnimationView pop_addAnimation:animation1 forKey:@"key_alpha_animtion1"];
  POPBasicAnimation * animation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
  animation2.fromValue = @(1);
  animation2.toValue = @(0);
  animation2.duration = 0.333;
  animation2.beginTime = CACurrentMediaTime() + 0.333;
  [self.theCenterAnimationView pop_addAnimation:animation2 forKey:@"key_alpha_animtion2"];
  POPBasicAnimation * animation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
  animation3.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
  animation3.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
  animation3.duration = 0.666;
  [self.theCenterAnimationView pop_addAnimation:animation3 forKey:@"key_scale_animtion3"];
}
#pragma mark - lazy UI
- (UIImageView * )theCenterAnimationView{
  if (!_theCenterAnimationView) {
    UIImageView * theView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DSize(159), DSize(219))];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.size.mas_equalTo(theView.frame.size);
    }];
    theView.contentMode = UIViewContentModeScaleAspectFit;
    _theCenterAnimationView = theView;
  }
  return _theCenterAnimationView;
}
@end
