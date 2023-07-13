#import "PPWawajiResultViewController.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "UIImageView+WebCache.h"
#import "PPImageUtil.h"
#import "AppDefineHeader.h"


@interface PPWawajiResultViewController ()
@property (nonatomic, weak) UIView * theContentView;
@property (nonatomic, weak) UIButton * theCloseButton;
@property (nonatomic, weak) UIImageView * theTopLogoImageView;
@property (nonatomic, weak) UIView * theCenterResultContentView;
@property (nonatomic, weak) UIImageView * theWinResultBgImageView;
@property (nonatomic, weak) UIImageView * theResultImageView;
@property (nonatomic, weak) UILabel * theResultTitleLabel;
@property (nonatomic, weak) UILabel * theResultDetailLabel;
@property (nonatomic, weak) UIButton * theSharedButton;
@property (nonatomic, weak) UIButton * thePlayAgainButton;
@property (nonatomic, assign) NSInteger currentProtectionSeconds;
@property (nonatomic, strong) NSTimer * runTimer;
@end
@implementation PPWawajiResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  [self configView];
  [self configData];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.isOtherPlay) {
    [self startAutoHideResultView];
  }
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}
#pragma mark - config
- (void)configView {
  [self theContentView];
  [self theCloseButton];
  [self theTopLogoImageView];
  [self theCenterResultContentView];
  [self createPointView:0];
  [self createPointView:1];
  [self createPointView:2];
  [self createPointView:3];
  [self theWinResultBgImageView];
  [self theResultImageView];
  [self theResultTitleLabel].text = @"就差一点点";
  self.theResultDetailLabel.text = @"多玩几次可能会有惊喜哟～";
  [self theSharedButton];
  [self thePlayAgainButton];
}
- (void)configData {
  self.doneSubject = [RACSubject subject];
  if (self.resultData) {
    if (self.resultData.value == 1) {
      NSString * win_img_url = self.resultData.img;
      [self.theResultImageView sd_setImageWithURL:[NSURL URLWithString:win_img_url]];
    } else {
      [_theWinResultBgImageView removeFromSuperview];
      [_theSharedButton removeFromSuperview];
      [self.thePlayAgainButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DSize(278));
        make.height.mas_equalTo(DSize(84));
        make.centerX.equalTo(self.theContentView);
        make.bottom.equalTo(self.theContentView).offset(DSize(-50));
      }];
    }
  }
  if (self.isOtherPlay) {
    [self.theContentView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(DSize(686));
    }];
    [_theSharedButton removeFromSuperview];
    [_thePlayAgainButton removeFromSuperview];
  } else {
    [self start_run_down_time];
  }
}
- (void)createPointView:(NSInteger)tag {
  UIView * theView = [[UIView alloc] init];
  theView.layer.cornerRadius = DSize(7);
  theView.backgroundColor = [UIColor colorForHex:@"#F8F09B"];
  [self.theCenterResultContentView addSubview:theView];
  [theView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(DSize(14));
    make.height.mas_equalTo(DSize(14));
    if (tag == 0) {
      make.left.equalTo(self.theCenterResultContentView).offset(DSize(10));
      make.top.equalTo(self.theCenterResultContentView).offset(DSize(10));
    } else if (tag == 1) {
      make.right.equalTo(self.theCenterResultContentView.mas_right).offset(DSize(-10));
      make.top.equalTo(self.theCenterResultContentView).offset(DSize(10));
    } else if (tag == 2) {
      make.left.equalTo(self.theCenterResultContentView).offset(DSize(10));
      make.bottom.equalTo(self.theCenterResultContentView.mas_bottom).offset(DSize(-10));
    } else if (tag == 3) {
      make.bottom.equalTo(self.theCenterResultContentView.mas_bottom).offset(DSize(-10));
      make.right.equalTo(self.theCenterResultContentView.mas_right).offset(DSize(-10));
    }
  }];
}
#pragma mark - count down
- (void)start_run_down_time
{
  if (self.runTimer) {
    [self.runTimer invalidate];
    self.runTimer = nil;
  }
  self.runTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(down_run_time) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.runTimer forMode:NSDefaultRunLoopMode];
  self.currentProtectionSeconds = self.resultData.protection_seconds;
}
- (void)stop_run_down_time
{
  if (self.runTimer) {
    [self.runTimer invalidate];
    self.runTimer = nil;
  }
}
- (void)down_run_time {
  self.currentProtectionSeconds -= 1;
  if (self.currentProtectionSeconds < 0) {
    self.currentProtectionSeconds = 0;
    [self stop_run_down_time];
  }
}
- (void)startAutoHideResultView {
  @weakify_self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    @strongify_self;
    [self dismissViewControllerAnimated:false completion:nil];
  });
}
#pragma mark - set
- (void)setCurrentProtectionSeconds:(NSInteger)currentProtectionSeconds {
  _currentProtectionSeconds = currentProtectionSeconds;
  NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] init];
  [attributedStr appendAttributedString: [[NSAttributedString alloc] initWithString:@"再来一局" attributes:@{NSFontAttributeName: AutoPxFont(26), NSForegroundColorAttributeName: [UIColor blackColor]}]];
  if (self.currentProtectionSeconds > 0) {
    [attributedStr appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"(%lds)", self.currentProtectionSeconds] attributes:@{NSFontAttributeName: AutoPxFont(26), NSForegroundColorAttributeName: [UIColor colorForHex:@"#F95556"]}]];
  }
  [self.thePlayAgainButton setAttributedTitle:[attributedStr copy] forState:UIControlStateNormal];
}
#pragma mark - action
- (void)onClosePress:(id)sender {
  [self stop_run_down_time];
  [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)onSharedPress:(id)sender {
  [self dismissViewControllerAnimated:false completion:^{
    [self.doneSubject sendNext:@(sharedAction)];
  }];
}
- (void)onPlayAnginPress:(id)sender {
  [self dismissViewControllerAnimated:false completion:^{
    if (self.currentProtectionSeconds > 0) {
      [self.doneSubject sendNext:@(playAngin)];
    } else {
      [self.doneSubject sendNext:@(playAppointment)];
    }
  }];
}
#pragma mark - lazy
- (UIView * )theContentView{
  if (!_theContentView) {
    UIView * theView = [[UIView alloc] init];
    [self.view addSubview:theView];
    theView.backgroundColor = [UIColor colorForHex:@"#F8F09B"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.view);
      make.width.mas_equalTo(DSize(628));
      make.height.mas_equalTo(DSize(820));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(20);
    _theContentView = theView;
  }
  return _theContentView;
}
- (UIButton * )theCloseButton{
  if (!_theCloseButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(54));
      make.height.mas_equalTo(DSize(54));
      make.top.equalTo(self.theContentView.mas_top).offset(DSize(-27));
      make.right.equalTo(self.theContentView.mas_right).offset(DSize(27));
    }];
    theView.layer.cornerRadius = DSize(27);
    theView.layer.borderWidth = DSize(5);
    theView.layer.borderColor = [UIColor colorForHex:@"#F45450"].CGColor;
    theView.backgroundColor = [UIColor colorForHex:@"#F78F73"];
    [theView setImage:[PPImageUtil imageNamed:@"ico_result_close"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onClosePress:) forControlEvents:UIControlEventTouchUpInside];
    _theCloseButton = theView;
  }
  return _theCloseButton;
}
- (UIImageView * )theTopLogoImageView{
  if (!_theTopLogoImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.theContentView).offset(DSize(27));
      make.left.equalTo(self.theContentView).offset(DSize(24));
      make.width.mas_equalTo(DSize(101));
      make.height.mas_equalTo(DSize(55));
    }];
    theView.image = [PPImageUtil imageNamed:@"ico_result_top_logo"];
    _theTopLogoImageView = theView;
  }
  return _theTopLogoImageView;
}
- (UIView * )theCenterResultContentView{
  if (!_theCenterResultContentView) {
    UIView * theView = [[UIView alloc] init];
    [self.theContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theContentView);
      make.top.equalTo(self.theContentView).offset(DSize(114));
      make.width.mas_equalTo(DSize(580));
      make.height.mas_equalTo(DSize(538));
    }];
    theView.layer.cornerRadius = DSize(10);
    theView.backgroundColor = [UIColor whiteColor];
    _theCenterResultContentView = theView;
  }
  return _theCenterResultContentView;
}
- (UIImageView * )theWinResultBgImageView{
  if (!_theWinResultBgImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theCenterResultContentView addSubview:theView];
    theView.image = [PPImageUtil imageNamed:@"ico_win_result_bg"];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.theCenterResultContentView);
      make.centerX.equalTo(self.theCenterResultContentView);
      make.width.mas_equalTo(DSize(417));
      make.height.mas_equalTo(DSize(417));
    }];
    _theWinResultBgImageView = theView;
  }
  return _theWinResultBgImageView;
}
- (UIImageView * )theResultImageView{
  if (!_theResultImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theCenterResultContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theCenterResultContentView);
      make.top.equalTo(self.theCenterResultContentView).offset(DSize(63));
      make.width.mas_equalTo(DSize(300));
      make.height.mas_equalTo(DSize(290));
    }];
    theView.image = [PPImageUtil imageNamed:@"ico_fail_lgoo"];
    _theResultImageView = theView;
  }
  return _theResultImageView;
}
- (UILabel * )theResultTitleLabel{
  if (!_theResultTitleLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theCenterResultContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theCenterResultContentView);
      make.bottom.equalTo(self.theCenterResultContentView).offset(DSize(-110));
    }];
      theView.font = AutoBoldPxFont(32);
    theView.textColor = [UIColor blackColor];
    _theResultTitleLabel = theView;
  }
  return _theResultTitleLabel;
}
- (UILabel * )theResultDetailLabel{
  if (!_theResultDetailLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theCenterResultContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theCenterResultContentView);
      make.bottom.equalTo(self.theCenterResultContentView).offset(DSize(-54));
    }];
      theView.font = AutoPxFont(26);
    theView.textColor = [UIColor colorForHex:@"#444444"];
    _theResultDetailLabel = theView;
  }
  return _theResultDetailLabel;
}
- (UIButton * )theSharedButton{
  if (!_theSharedButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(278));
      make.height.mas_equalTo(DSize(84));
      make.left.equalTo(self.theContentView).offset(DSize(24));
      make.bottom.equalTo(self.theContentView).offset(DSize(-50));
    }];
    theView.backgroundColor = [UIColor colorForHex:@"#F89D9C"];
    theView.layer.cornerRadius = DSize(10);
    [theView setTitle:@"炫耀一下" forState:UIControlStateNormal];
      theView.titleLabel.font = AutoPxFont(26);
    [theView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onSharedPress:) forControlEvents:UIControlEventTouchUpInside];
    _theSharedButton = theView;
  }
  return _theSharedButton;
}
- (UIButton * )thePlayAgainButton{
  if (!_thePlayAgainButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theContentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(278));
      make.height.mas_equalTo(DSize(84));
      make.right.equalTo(self.theContentView).offset(DSize(-24));
      make.bottom.equalTo(self.theContentView).offset(DSize(-50));
    }];
    theView.backgroundColor = [UIColor colorForHex:@"#64E2BC"];
    theView.layer.cornerRadius = DSize(10);
    [theView setTitle:@"再来一局" forState:UIControlStateNormal];
      theView.titleLabel.font = AutoPxFont(26);
    [theView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onPlayAnginPress:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayAgainButton = theView;
  }
  return _thePlayAgainButton;
}
@end
