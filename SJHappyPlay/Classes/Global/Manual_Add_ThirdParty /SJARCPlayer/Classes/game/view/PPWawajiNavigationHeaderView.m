#import "PPWawajiNavigationHeaderView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPWawajiNavigationHeaderView ()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) UIImageView * theNavigationTitleBgImageView;
@property (nonatomic, weak) UILabel * theNavigationTitleLabel;
@end
@implementation PPWawajiNavigationHeaderView
@synthesize backSubject = _backSubject;
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, DSize(88));
    [self theBgImageView];
    [self theBackButton];
    [self theNavigationTitleBgImageView];
  }
  return self;
}
- (void)setTitle:(NSString *)title {
  _title = title;
  self.theNavigationTitleLabel.text = self.title;
}
- (void)onTapBackPress: (id)sender {
  [[self backSubject] sendNext:sender];
}
#pragma mark - lazy UI
- (UIImageView * )theBgImageView{
  if (!_theBgImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_navigation_header_bg"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.width.mas_equalTo(DSize(710));
      make.height.mas_equalTo(DSize(34));
    }];
      theView.hidden = YES;
    _theBgImageView = theView;
  }
  return _theBgImageView;
}
- (UIButton * )theBackButton{
  if (!_theBackButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView setImage:[PPImageUtil imageNamed:@"img_dbj_exit_a"] forState:UIControlStateNormal];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.width.mas_equalTo(35);
      make.centerY.equalTo(self);
      make.leading.equalTo(self.mas_leading).offset(14);
    }];
    [theView addTarget:self action:@selector(onTapBackPress:) forControlEvents:UIControlEventTouchUpInside];
    _theBackButton = theView;
  }
  return _theBackButton;
}
- (UIImageView * )theNavigationTitleBgImageView{
  if (!_theNavigationTitleBgImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_title_bg"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(432));
      make.height.mas_equalTo(DSize(59));
      make.center.equalTo(self);
    }];
      theView.hidden = YES;
    _theNavigationTitleBgImageView = theView;
  }
  return _theNavigationTitleBgImageView;
}
- (UILabel * )theNavigationTitleLabel{
  if (!_theNavigationTitleLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.theNavigationTitleBgImageView);
      make.width.mas_equalTo(DSize(373));
    }];
      theView.font = AutoPxFont(32);
      theView.hidden = YES;
    theView.textColor = [UIColor colorForHex:@"#333333"];
    theView.textAlignment = NSTextAlignmentCenter;
    _theNavigationTitleLabel = theView;
  }
  return _theNavigationTitleLabel;
}
- (RACSubject * )backSubject {
  if (!_backSubject) {
    _backSubject = [RACSubject subject];
  }
  return _backSubject;
}
@end
