#import "PPNetworkStatusView.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPNetworkStatusView ()
@property (nonatomic, weak) UIView * theWifiStatusView;
@property (nonatomic, weak) UIImageView * theWifiStatusImageView;
@property (nonatomic, weak) UILabel * theWifiStatusLabel;
@end
@implementation PPNetworkStatusView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(80), SF_Float(48));
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
  self.layer.masksToBounds = true;
  self.layer.cornerRadius = SF_Float(24);
  [self theWifiStatusView];
  [self theWifiStatusImageView];
  [self theWifiStatusLabel];
}
#pragma mark - set
- (void)setQuality:(NSInteger)quality {
  _quality = quality;
}
#pragma mark - lazy UI
- (UIView * )theWifiStatusView{
  if (!_theWifiStatusView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.width.and.height.mas_equalTo(SF_Float(30));
      make.left.equalTo(self).offset(SF_Float(7));
    }];
    theView.layer.cornerRadius = SF_Float(15);
    theView.layer.masksToBounds = true;
    _theWifiStatusView = theView;
  }
  return _theWifiStatusView;
}
- (UIImageView * )theWifiStatusImageView{
  if (!_theWifiStatusImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theWifiStatusView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.theWifiStatusView);
      make.width.mas_equalTo(SF_Float(23));
      make.height.mas_equalTo(SF_Float(18));
    }];
    theView.image = [PPImageUtil imageNamed:@"ico_wifi_1"];
    _theWifiStatusImageView = theView;
  }
  return _theWifiStatusImageView;
}
- (UILabel * )theWifiStatusLabel{
  if (!_theWifiStatusLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
      theView.font = AutoPxFont(14);
    theView.textColor = [UIColor colorForHex:@"#55FF6D"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self.theWifiStatusView.mas_right).offset(SF_Float(7));
      make.height.mas_equalTo(SF_Float(35));
      make.width.mas_equalTo(SF_Float(30));
    }];
    theView.text = @"网络\n较好";
    theView.numberOfLines = 2;
    _theWifiStatusLabel = theView;
  }
  return _theWifiStatusLabel;
}
@end
