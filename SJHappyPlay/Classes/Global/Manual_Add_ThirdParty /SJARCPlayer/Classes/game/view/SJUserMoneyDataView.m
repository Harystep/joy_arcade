
#import "SJUserMoneyDataView.h"
#import "PPSaintGameValueView.h"
#import "PPImageUtil.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"

@interface SJUserMoneyDataView ()

@property (nonatomic, weak) PPSaintGameValueView * theGameCoinView;
@property (nonatomic, weak) PPSaintGameValueView * theGamePointView;
@property (nonatomic,strong) UIView *coinContentBgView;

@end

@implementation SJUserMoneyDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self coinContentBgView];
}

- (UIView *)coinContentBgView{
  if (!_coinContentBgView) {
      _coinContentBgView = [[UIView alloc] init];
      [self addSubview:_coinContentBgView];
      [_coinContentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.mas_equalTo(self);
          make.height.mas_equalTo(DSize(56));
      }];
      _coinContentBgView.layer.cornerRadius = DSize(28);
      _coinContentBgView.layer.masksToBounds = YES;
      _coinContentBgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.50);
      [self theGameCoinView];
      
      [self theGamePointView];
      
  }
  return _coinContentBgView;
}

- (PPSaintGameValueView * )theGameCoinView{
  if (!_theGameCoinView) {
    PPSaintGameValueView * theView = [[PPSaintGameValueView alloc] initWithValueType:SDGameValue_Coin];
//    [theView addTarget:self action:@selector(onTapChargeCoinPress:) forControlEvents:UIControlEventTouchUpInside];
      [self.coinContentBgView addSubview:theView];
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.coinContentBgView.mas_leading).offset(DSize(20));
        make.width.mas_equalTo(theView.frame.size.width);
          make.height.mas_equalTo(DSize(56));
          make.centerY.mas_equalTo(_coinContentBgView.mas_centerY);
      }];
    _theGameCoinView = theView;
  }
  return _theGameCoinView;
}
- (PPSaintGameValueView * )theGamePointView{
  if (!_theGamePointView) {
    PPSaintGameValueView * theView = [[PPSaintGameValueView alloc] initWithValueType:SDGameValue_point];
//    [theView addTarget:self action:@selector(onTapPointPress:) forControlEvents:UIControlEventTouchUpInside];
      [self.coinContentBgView addSubview:theView];
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.theGameCoinView.mas_trailing).offset(DSize(10));
        make.width.mas_equalTo(theView.frame.size.width);
          make.height.mas_equalTo(DSize(56));
          make.centerY.mas_equalTo(_coinContentBgView.mas_centerY);
          make.trailing.mas_equalTo(_coinContentBgView.mas_trailing);
      }];
    _theGamePointView = theView;
  }
  return _theGamePointView;
}

- (void)setPriceValue:(NSString *)priceValue {
    _priceValue = priceValue;
    self.theGameCoinView.gameValue = [priceValue integerValue];
}

- (void)setPointValue:(NSString *)pointValue {
    _pointValue = pointValue;
    self.theGamePointView.gameValue = [pointValue integerValue];
}

@end
