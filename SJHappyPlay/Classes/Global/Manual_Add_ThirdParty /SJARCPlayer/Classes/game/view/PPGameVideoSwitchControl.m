#import "PPGameVideoSwitchControl.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGameVideoSwitchControl ()
@property (nonatomic, weak) UIImageView * theSwitchImageView;
@property (nonatomic, weak) UILabel * theTitleLabel;
@end
@implementation PPGameVideoSwitchControl
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(112), SF_Float(88));
    self.backgroundColor = [UIColor colorForHex:@"#FAE55E"];
    [self configView];
  }
  return self;
}
- (void)configView {
  UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii: CGSizeMake(SF_Float(44), 0)];
  CAShapeLayer * shapLayer = [[CAShapeLayer alloc] init];
  shapLayer.frame = self.bounds;
  shapLayer.path = path.CGPath;
  self.layer.mask = shapLayer;
  [self theSwitchImageView];
  self.theTitleLabel.text = @"切换视角";
}
- (UIImageView * )theSwitchImageView{
  if (!_theSwitchImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_video_change"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self).offset(SF_Float(8));
      make.top.equalTo(self).offset(SF_Float(12));
      make.width.mas_equalTo(SF_Float(77));
      make.height.mas_equalTo(SF_Float(38));
    }];
    _theSwitchImageView = theView;
  }
  return _theSwitchImageView;
}
- (UILabel * )theTitleLabel{
  if (!_theTitleLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
      theView.font = AutoPxFont(16);
    theView.textColor = [UIColor colorForHex:@"#8E6733"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self).offset(SF_Float(8));
      make.top.equalTo(self.theSwitchImageView.mas_bottom).offset(SF_Float(8));
    }];
    _theTitleLabel = theView;
  }
  return _theTitleLabel;
}
@end
