#import "PPSaintGameValueView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "UICountingLabel.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

#define minWidth 100
@interface PPSaintGameValueView ()
@property (nonatomic, weak) UIImageView * theLogoImageView;
@property (nonatomic, weak) UICountingLabel * theValueLabel;
@property (nonatomic, weak) UIView * theGameValueBgView;
@end
@implementation PPSaintGameValueView
- (instancetype)initWithValueType:(SDGameValueType)type
{
  self = [super init];
  if (self) {
    self.valueType = type;
    self.frame = CGRectMake(0, 0, DSize(minWidth), DSize(50));
    [self configView];
  }
  return self;
}
- (instancetype)initWithForGoldLegendValueType:(SDGameValueType)type
{
  self = [super init];
  if (self) {
    self.valueType = type;
    self.frame = CGRectMake(0, 0, DSize(minWidth), DSize(64));
    [self configView];
    
      self.theValueLabel.font = AutoMediumPxFont(30);
    if (self.valueType == SDGameValue_Coin) {
      
    }
  }
  return self;
}
#pragma mark - config
- (void)configView {
    [self theGameValueBgView];
  [self theLogoImageView];
  [self.theValueLabel countFromZeroTo:0];
  if (self.valueType == SDGameValue_Coin) {//img_game_point img_game_coin img_game_diamond
    self.theLogoImageView.image = [PPImageUtil imageNamed:@"img_game_coin_a"];
  } else {
    self.theLogoImageView.image = [PPImageUtil imageNamed:@"img_game_point_a"];
  }
}
#pragma mark - set
- (void)setGameValue:(NSInteger)gameValue {
  NSInteger currentValue = gameValue;
  _gameValue = gameValue;
  CGSize valueSize = [[NSString stringWithFormat:@"%ld", gameValue] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.theValueLabel.font} context:nil].size;
  CGFloat valueWidth = 0;
    valueWidth = DSize(50) + DSize(20) + valueSize.width + DSize(10);
  [self mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(valueWidth);
  }];
  [self.theValueLabel countFrom:currentValue to:self.gameValue withDuration:0.3];
}
#pragma mark - lazy UI
- (UIImageView * )theLogoImageView{
  if (!_theLogoImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_saint_coin"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self);
      make.width.and.height.mas_equalTo(DSize(50));
    }];
    _theLogoImageView = theView;
  }
  return _theLogoImageView;
}

- (UIView *)theGameValueBgView{
    if (!_theGameValueBgView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(DSize(10));
            make.right.equalTo(self);
            if (self.valueType == SDGameValue_Coin) {
                make.centerY.equalTo(self);
            } else {
                make.top.equalTo(self).offset(DSize(13));
            }
            make.height.mas_equalTo(DSize(36));
        }];
        _theGameValueBgView = theView;
    }
    return _theGameValueBgView;
}
- (UICountingLabel * )theValueLabel{
  if (!_theValueLabel) {
    UICountingLabel * theView = [[UICountingLabel alloc] init];
    [self.theGameValueBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.theGameValueBgView);
        make.right.equalTo(self.theGameValueBgView).offset(-5);
        make.leading.mas_equalTo(self.theLogoImageView.mas_trailing).offset(2);
    }];
      theView.font = AutoMediumPxFont(26);
    theView.textColor = [UIColor whiteColor];
    theView.format = @"%ld";
    _theValueLabel = theView;
  }
  return _theValueLabel;
}

@end
