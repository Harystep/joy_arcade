#import "PPGameSuccessResultView.h"
#import "PPOutlineLabel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGameSuccessResultView ()
@property (nonatomic, weak) UIImageView * theResultBgView;
@property (nonatomic, weak) UIView * theTitleView;
@property (nonatomic, weak) UILabel * theleftContentLabel;
@property (nonatomic, weak) UIImageView * theRewardLogoView;
@property (nonatomic, weak) PPOutlineLabel * theRewardNumLabel;
@property (nonatomic, weak) UILabel * theRightContentLabel;
@property (nonatomic, weak) UILabel * theBottomContentLabel;
@property (nonatomic, weak) UIImageView * theWinLogoImageView;
@property (nonatomic, weak) PPOutlineLabel * theWinLogoNumLabel;
@property (nonatomic, weak) UIImageView * theWinRewardImageView;
@end
@implementation PPGameSuccessResultView
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configView];
  }
  return self;
}
- (void)configView{
  self.frame = CGRectMake(0, 0, SF_Float(403), SF_Float(439));
  [self theResultBgView];
  [self theTitleView].hidden = true;
  [self theleftContentLabel].hidden = true;
  [self theRewardLogoView].hidden = true;
  [self theRightContentLabel].hidden = true;
  [self theBottomContentLabel].hidden = true;
  [self theRewardNumLabel].hidden = true;
  [self theWinLogoImageView].hidden = true;
  [self theWinRewardImageView].hidden = true;
  [self theWinLogoNumLabel].hidden = true;
}
- (void)displayOtherPlay{
  self.theTitleView.hidden = true;
}
#pragma mark - public method
- (void)displayView{
  if (self.type == 1) {
    self.theTitleView.hidden = false;
    self.theleftContentLabel.text = @"好棒哦！成功抓中一个";
    self.theleftContentLabel.hidden = false;
    self.theRewardLogoView.hidden = true;
    self.theRewardNumLabel.hidden = true;
  }else {
    if (self.level >= 0) {
      self.theTitleView.hidden = false;
      self.theleftContentLabel.text = @"恭喜你！成功抓中";
      self.theleftContentLabel.hidden = false;
      self.theRewardLogoView.hidden = false;
      self.theRightContentLabel.hidden = false;
      self.theBottomContentLabel.hidden = false;
      if (self.level > 0) {
        self.theRewardNumLabel.hidden = false;
      }
    }else {
    }
  }
}
#pragma mark - set method
- (void)setGame_win_image_url:(NSString *)game_win_image_url{
  _game_win_image_url = game_win_image_url;
  if (self.game_win_image_url) {
    self.theWinLogoImageView.hidden = false;
    [self.theWinLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.game_win_image_url]];
  }
}
- (void)setBallNum:(NSInteger)ballNum{
  _ballNum = ballNum;
  self.theRewardNumLabel.text = [NSString stringWithFormat:@"%ld", self.ballNum];
  self.theWinLogoNumLabel.text = [NSString stringWithFormat:@"%ld", self.ballNum];
}
#pragma mark - lazy UI
- (UIImageView *)theResultBgView{
  if (!_theResultBgView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_game_result_success_bgView"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.width.mas_equalTo(SF_Float(373));
      make.height.mas_equalTo(SF_Float(439));
    }];
    _theResultBgView = theView;
  }
  return _theResultBgView;
}
- (UIView *)theTitleView{
  if (!_theTitleView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(403));
      make.height.mas_equalTo(SF_Float(107));
      make.centerX.equalTo(self);
      make.top.equalTo(self).offset(SF_Float(25));
    }];
    _theTitleView = theView;
  }
  return _theTitleView;
}
- (UILabel *)theleftContentLabel{
  if (!_theleftContentLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theTitleView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theTitleView);
      make.top.equalTo(self.theTitleView).offset(SF_Float(24));
    }];
      theView.font = AutoPxFont(34);
    theView.textColor = [UIColor colorForHex:@"#F6E60A"];
    theView.text = @"恭喜你！成功抓中";
    _theleftContentLabel = theView;
  }
  return _theleftContentLabel;
}
- (UIImageView *)theRewardLogoView{
  if (!_theRewardLogoView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theTitleView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theleftContentLabel.mas_right).offset(SF_Float(15));
      make.centerY.equalTo(self.theleftContentLabel);
      make.width.mas_equalTo(SF_Float(75));
      make.height.mas_equalTo(SF_Float(75));
    }];
    _theRewardLogoView = theView;
  }
  return _theRewardLogoView;
}
- (PPOutlineLabel *)theRewardNumLabel{
  if (!_theRewardNumLabel) {
    PPOutlineLabel * theView = [[PPOutlineLabel alloc] init];
    [self.theTitleView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.theRewardLogoView);
      make.width.and.height.mas_equalTo(SF_Float(72));
    }];
    theView.textAlignment = NSTextAlignmentCenter;
    theView.lineBreakMode = NSLineBreakByWordWrapping;
    theView.outLinetextColor = [UIColor blackColor];
    theView.labelTextColor = [UIColor whiteColor];
    theView.outLineWidth = 0.5;
      theView.font = AutoPxFont(20);
    _theRewardNumLabel = theView;
  }
  return _theRewardNumLabel;
}
- (UILabel *)theRightContentLabel{
  if (!_theRightContentLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theTitleView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theRewardLogoView.mas_right).offset(SF_Float(15));
      make.centerY.equalTo(self.theRewardLogoView);
    }];
      theView.font = AutoPxFont(34);
    theView.textColor = [UIColor colorForHex:@"#F6E60A"];
    theView.text = @"球";
    _theRightContentLabel = theView;
  }
  return _theRightContentLabel;
}
- (UILabel *)theBottomContentLabel{
  if (!_theBottomContentLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theTitleView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theTitleView);
      make.top.equalTo(self.theRewardLogoView.mas_bottom);
    }];
      theView.font = AutoPxFont(34);
    theView.textColor = [UIColor colorForHex:@"#F6E60A"];
    theView.text = @"获得";
    _theBottomContentLabel = theView;
  }
  return _theBottomContentLabel;
}
- (UIImageView *)theWinLogoImageView{
  if (!_theWinLogoImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(238));
      make.height.mas_equalTo(SF_Float(238));
      make.centerX.equalTo(self);
      make.bottom.equalTo(self).offset(SF_Float(-42));
    }];
    _theWinLogoImageView = theView;
  }
  return _theWinLogoImageView;
}
- (UIImageView *)theWinRewardImageView{
  if (!_theWinRewardImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(100));
      make.height.mas_equalTo(SF_Float(100));
      make.centerX.equalTo(self);
      make.bottom.equalTo(self).offset(SF_Float(-42));
    }];
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
      make.width.and.height.mas_equalTo(SF_Float(72));
    }];
    theView.textAlignment = NSTextAlignmentCenter;
    theView.lineBreakMode = NSLineBreakByWordWrapping;
    theView.outLinetextColor = [UIColor blackColor];
    theView.labelTextColor = [UIColor whiteColor];
    theView.outLineWidth = 0.5;
      theView.font = AutoPxFont(20);
    _theWinLogoNumLabel = theView;
  }
  return _theWinLogoNumLabel;
}
@end
