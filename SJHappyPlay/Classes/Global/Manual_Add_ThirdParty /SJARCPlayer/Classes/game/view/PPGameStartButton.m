#import "PPGameStartButton.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"

#import "AppDefineHeader.h"

@interface PPGameStartButton ()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) UILabel * thePriceLabel;
@property (nonatomic, weak) UILabel * theGameStatusLabel;
@end
@implementation PPGameStartButton
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
  [self theBgImageView];
}
#pragma mark - public method
- (void)showAppointmentInfo {
  if (self.btStatus == appointmentAction) {
    self.theGameStatusLabel.text = [ZCLocal(@"预约游戏") stringByAppendingFormat:@"(%ld)", self.appointmentCount];
  } else if (self.btStatus == cancelAppointmentAction) {
    self.theGameStatusLabel.text = [ZCLocal(@"取消预约") stringByAppendingFormat:@"(%ld)", self.appointmentCount];
  }
}
#pragma mark - set
- (void)setBtStatus:(GameButtonStatus)btStatus {
  _btStatus = btStatus;
  switch (self.btStatus) {
    case startAction:
      self.theBgImageView.image = self.startGameImage;
      self.theGameStatusLabel.text = ZCLocal(@"开始游戏");
      break;
    case appointmentAction:
      self.theBgImageView.image = self.appointmentImage;
      self.theGameStatusLabel.text = ZCLocal(@"预约游戏");
      break;
    case cancelAppointmentAction:
      self.theBgImageView.image = self.cancelAppointmentImage;
      self.theGameStatusLabel.text = ZCLocal(@"取消预约");
      break;
    default:
      break;
  }
}
- (void)setGamePrice:(NSString *)gamePrice {
  _gamePrice = gamePrice;
  self.thePriceLabel.text = [NSString stringWithFormat:@"%@/%@",self.gamePrice, ZCLocal(@"次")];
}
- (void)setAppointmentCount:(NSInteger)appointmentCount {
  _appointmentCount = appointmentCount;
}
#pragma mark - lazy UI
- (UIImageView * )theBgImageView{
  if (!_theBgImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    _theBgImageView = theView;
  }
  return _theBgImageView;
}
- (UILabel * )thePriceLabel{
  if (!_thePriceLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self).offset(SF_Float(69));
    }];
      theView.font = AutoPxFont(20);
    theView.textColor = [UIColor whiteColor];
    _thePriceLabel = theView;
  }
  return _thePriceLabel;
}
- (UILabel * )theGameStatusLabel{
  if (!_theGameStatusLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
      theView.font = AutoMediumPxFont(32);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self).offset(SF_Float(28));
    }];
    _theGameStatusLabel = theView;
  }
  return _theGameStatusLabel;
}
@end
