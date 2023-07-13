#import "PPGameMyMoneyView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGameMyMoneyView ()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) UIView * thePriceBgView;
@property (nonatomic, weak) UILabel * thePriceLabel;
@property (nonatomic, weak) UIView * thePointBgView;
@property (nonatomic, weak) UILabel * thePointLabel;
@end
@implementation PPGameMyMoneyView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(72));
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self theBgImageView];
  [self thePriceBgView];
    
}
#pragma mark - public method
- (void)setPriceValue:(NSString *)priceValue {
  _priceValue = priceValue;
  if (!self.priceName) {
    self.priceName = @"钻石";
  }
  self.thePriceLabel.text = [NSString stringWithFormat:@"%@：%@",self.priceName, self.priceValue];
}
- (void)setPointValue:(NSString *)pointValue {
  _pointValue = pointValue;
  self.thePointLabel.text = [NSString stringWithFormat:@"积分: %@",self.pointValue];
}
- (void)chagnePushCoinModel {
  self.theBgImageView.hidden = true;
  self.thePriceBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
  self.thePriceLabel.textColor = [UIColor whiteColor];
  self.priceName = @"金币";
  self.thePointBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
  self.thePointLabel.textColor = [UIColor whiteColor];
  [self.thePriceBgView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.mas_centerX).offset(-SF_Float(155));
  }];
  [self.thePointBgView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.mas_centerX).offset(SF_Float(155));
  }];
}
#pragma mark - lazy UI
- (UIImageView * )theBgImageView{
  if (!_theBgImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_game_price_line"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(710));
      make.height.mas_equalTo(SF_Float(18));
      make.center.equalTo(self);
    }];
    _theBgImageView = theView;
  }
  return _theBgImageView;
}
- (UIView * )thePriceBgView{
  if (!_thePriceBgView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.centerY.equalTo(self);
      make.width.mas_equalTo(SF_Float(300));
      make.height.mas_equalTo(SF_Float(44));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(22);
    theView.backgroundColor = [UIColor colorForHex:@"#F4D534"];
    _thePriceBgView = theView;
  }
  return _thePriceBgView;
}
- (UILabel * )thePriceLabel{
  if (!_thePriceLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePriceBgView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor colorForHex:@"#8E6733"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePriceBgView);
    }];
    _thePriceLabel = theView;
  }
  return _thePriceLabel;
}
- (UIView * )thePointBgView{
  if (!_thePointBgView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.centerY.equalTo(self);
      make.width.mas_equalTo(SF_Float(300));
      make.height.mas_equalTo(SF_Float(44));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(22);
    theView.backgroundColor = [UIColor colorForHex:@"#F4D534"];
    _thePointBgView = theView;
  }
  return _thePointBgView;
}
- (UILabel * )thePointLabel{
  if (!_thePointLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePointBgView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor colorForHex:@"#8E6733"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePointBgView);
    }];
    _thePointLabel = theView;
  }
  return _thePointLabel;
}
@end
