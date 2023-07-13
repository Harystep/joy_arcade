#import "PPGameFailResultView.h"
#import "PPOutlineLabel.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGameFailResultView ()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) UILabel * theFailLable;
@property (nonatomic, weak) UIImageView * theFailLogoImageView;
@property (nonatomic, weak) PPOutlineLabel * theWinLogoNumLabel;
@property (nonatomic, weak) UIImageView * theWinRewardImageView;
@end
@implementation PPGameFailResultView
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configView];
  }
  return self;
}
- (void)configView{
  self.frame = CGRectMake(0, 0, DSize(411), DSize(406));
  [self theBgImageView];
  [self theFailLable];
  [self theFailLogoImageView];
}
- (void)setTitleStr:(NSString *)titleStr{
  _titleStr = titleStr;
  self.theFailLable.text = titleStr;
}
- (void)setTheRewardLogoImage:(UIImage *)theRewardLogoImage{
  _theRewardLogoImage = theRewardLogoImage;
  if (self.theRewardLogoImage) {
    self.theWinRewardImageView.image = self.theRewardLogoImage;
    self.theWinRewardImageView.hidden = false;
    self.theFailLogoImageView.hidden = true;
  }else {
    self.theWinRewardImageView.hidden = true;
    self.theFailLogoImageView.hidden = true;
  }
}
- (void)setBallNum:(NSInteger)ballNum{
  _ballNum = ballNum;
  self.theWinLogoNumLabel.text = [NSString stringWithFormat:@"%ld",self.ballNum];
  self.theWinLogoNumLabel.hidden = false;
}
- (void)setLevel:(NSInteger)level{
  _level = level;
  if (self.level >= 0 ) {
    switch (self.level) {
      case 0:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_te"];
        break;
      case 1:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_1"];
        break;
      case 2:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_2"];
        break;
      case 3:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_3"];
        break;
      case 4:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_4"];
        break;
      case 5:
        self.theWinRewardImageView.image = [PPImageUtil imageNamed:@"ico_reward_5"];
        break;
      default:
        break;
    }
  }else {
    self.theWinRewardImageView.image= [PPImageUtil imageNamed:@"ico_reward_0"];
  }
  self.theWinRewardImageView.hidden = false;
}
#pragma mark - lazy UI
- (UIImageView *)theBgImageView{
  if (!_theBgImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(411));
      make.height.mas_equalTo(DSize(406));
      make.center.equalTo(self);
    }];
    theView.image = [PPImageUtil imageNamed:@"resultcatchFailed"];
    _theBgImageView = theView;
  }
  return _theBgImageView;
}
- (UILabel *)theFailLable{
  if (!_theFailLable) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self).offset(DSize(72));
    }];
      theView.font = AutoPxFont(34);
    theView.textColor = [UIColor colorForHex:@"#F6E60A"];
    theView.text = @"不要灰心，继续努力";
    _theFailLable = theView;
  }
  return _theFailLable;
}
- (UIImageView *)theFailLogoImageView{
  if (!_theFailLogoImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self.theFailLable.mas_bottom).offset(DSize(80));
      make.width.mas_equalTo(DSize(343));
      make.height.mas_equalTo(DSize(206));
    }];
    theView.image = [PPImageUtil imageNamed:@"ico_game_fail_logo_imageView"];
    _theFailLogoImageView = theView;
  }
  return _theFailLogoImageView;
}
- (UIImageView *)theWinRewardImageView{
  if (!_theWinRewardImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(100));
      make.height.mas_equalTo(DSize(100));
      make.centerX.equalTo(self);
      make.bottom.equalTo(self).offset(DSize(-42));
    }];
    theView.hidden = true;
    _theWinRewardImageView = theView;
  }
  return _theWinRewardImageView;
}
- (PPOutlineLabel *)theWinLogoNumLabel{
  if (!_theWinLogoNumLabel) {
    PPOutlineLabel * theView = [[PPOutlineLabel alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.theWinRewardImageView);
      make.width.and.height.mas_equalTo(DSize(72));
    }];
    theView.textAlignment = NSTextAlignmentCenter;
    theView.lineBreakMode = NSLineBreakByWordWrapping;
    theView.outLinetextColor = [UIColor blackColor];
    theView.labelTextColor = [UIColor whiteColor];
    theView.outLineWidth = 0.5;
      theView.font = AutoPxFont(28);
    theView.hidden = true;
    _theWinLogoNumLabel = theView;
  }
  return _theWinLogoNumLabel;
}
@end
