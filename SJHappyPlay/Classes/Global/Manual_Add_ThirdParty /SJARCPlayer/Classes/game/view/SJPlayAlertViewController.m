#import "SJPlayAlertViewController.h"
#import "SJPCSayQuickRequestModal.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"

#import "AppDefineHeader.h"

@interface SJPlayAlertViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, weak) UIView * theBgView;
@property (nonatomic, weak) UIView * theBottomButtonsView;
@property (nonatomic, weak) UIButton * theCancelButton;
@property (nonatomic, weak) UIButton * theSureButton;
@property (nonatomic, weak) UITextField * theInputChatView;
@property (nonatomic, weak) UILabel * theTitleLabel;
@property (nonatomic, weak) UILabel * theMessageLabel;
@property (nonatomic, strong) NSTimer  *runTimer;
@property (nonatomic, weak) UIScrollView * theScrollView;
@end
@implementation SJPlayAlertViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [self theBgView];
  [self theBottomButtonsView];
  [self theCancelButton];
  [self theSureButton];
  UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDissMissPress:)];
  tap.delegate = self;
  [self.view addGestureRecognizer:tap];
}
- (void)onDissMissPress:(UITapGestureRecognizer * )gesture{
  if (_theInputChatView) {
    [self.theInputChatView resignFirstResponder];
  }
}
- (void)setWaitSeconds:(NSInteger)waitSeconds{
  if (self.alertShowType == SDAlertShowAppmentPlay) {
    _waitSeconds = waitSeconds;
    if (self.waitSeconds >0) {
      NSString * sureStr = [NSString stringWithFormat:@"%@%ld", ZCLocal(@"开始游戏"), self.waitSeconds];
      [self.theSureButton setTitle:sureStr forState:UIControlStateNormal];
    }else {
      [self.theSureButton setTitle:ZCLocal(@"开始游戏") forState:UIControlStateNormal];
      [self.runTimer invalidate];
      self.runTimer = nil;
    }
  }
}
- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.alertShowType == SDAlertShowSendMessage) {
    [self theInputChatView].hidden = false;
    [self getFlastSay];
  }else {
    [self theInputChatView].hidden = true;
    self.theSureButton.enabled = true;
    [self theTitleLabel];
    [self theMessageLabel];
    [self.theBgView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(DSize(300));
    }];
  }
  @weakify_self;
  self.runTimer = [NSTimer timerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
    @strongify_self;
    self.waitSeconds = self.waitSeconds - 1;
  }];
  [[NSRunLoop mainRunLoop] addTimer:self.runTimer forMode:NSDefaultRunLoopMode];
}
- (void)getFlastSay{
  SJPCSayQuickRequestModal * requestModal = [[SJPCSayQuickRequestModal alloc] init];
  [requestModal requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
    if (!error) {
      SJPCSayQuickResponseModal * sayQuick = (SJPCSayQuickResponseModal * )responseModel;
      [self displayFlastSayView:sayQuick.data];
    }
  }];
}
- (void)displayFlastSayView:(NSArray * )sayList{
  [self theScrollView];
  CGFloat maxFlostx = DSize(20);
  for (NSInteger i = 0 ; i <  sayList.count; i ++) {
    NSString * sayStr = sayList[i];
      UIFont * font = AutoPxFont(24);
    UIColor * color = [UIColor colorForHex:@"#C92424"];
    CGSize textSize = [sayStr boundingRectWithSize:CGSizeMake(MAXFLOAT, DSize(50)) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    UIButton * thefalstButton = [[UIButton alloc] initWithFrame:CGRectMake(maxFlostx, DSize(15), textSize.width + DSize(60), DSize(50))];
    [thefalstButton setTitle:sayStr forState:UIControlStateNormal];
    [thefalstButton setTitleColor:color forState:UIControlStateNormal];
    thefalstButton.titleLabel.font = font;
    thefalstButton.layer.borderColor = [UIColor colorForHex:@"#f4f1f4"].CGColor;
    thefalstButton.layer.borderWidth = 1;
    thefalstButton.layer.cornerRadius = DSize(25);
    thefalstButton.backgroundColor = [UIColor colorForHex:@"#fbf8fb"];
    maxFlostx += thefalstButton.frame.size.width + DSize(20);
    [self.theScrollView addSubview:thefalstButton];
    [thefalstButton addTarget:self action:@selector(onTapFlastSayTagPress:) forControlEvents:UIControlEventTouchUpInside];
  }
}
- (void)onTapFlastSayTagPress:(id)sender{
  UIButton * btn = (UIButton * )sender;
  NSString * say = btn.titleLabel.text;
  NSString * originstr = self.theInputChatView.text;
  self.theInputChatView.text = [NSString stringWithFormat:@"%@%@",originstr,say];
  self.theSureButton.enabled = true;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isKindOfClass:[UIControl class]]) {
    return NO;
  }
  return YES;
}
#pragma mark - action
- (void)onCancelPress:(id)sender{
  [self dismissViewControllerAnimated:NO completion:nil];
  [self.runTimer invalidate];
  self.runTimer = nil;
}
- (void)onSurePress:(id)sender {
  [self.runTimer invalidate];
  self.runTimer = nil;
  [self dismissViewControllerAnimated:NO completion:nil];
  if (self.alertShowType == SDAlertShowSendMessage) {
    if (self.inputChatBlock) {
       self.inputChatBlock(self.theInputChatView.text);
     }
  }else {
    if (self.alertBlock) {
      if (self.waitSeconds > 0) {
        self.alertBlock(1);
      }else {
        self.alertBlock(2);
      }
    }
  }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
      [self onSurePress:nil];
    }
    return YES;
}

- (void)setupSubViewsCorner:(UIView *)view corner:(CGFloat)corner {
    view.layer.cornerRadius = corner;
    view.layer.masksToBounds = YES;
}

#pragma mark - lazy UI
- (UIView *)theBgView{
  if (!_theBgView) {
    UIView * theView = [[UIView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(600));
      make.height.mas_equalTo(DSize(400));
      make.center.equalTo(self.view);
    }];
    theView.layer.masksToBounds = true;
    theView.backgroundColor = [UIColor whiteColor];
    theView.layer.cornerRadius = 10;
    _theBgView = theView;
      
      UIView *contentBgView = [[UIView alloc] init];
      [_theBgView addSubview:contentBgView];
      contentBgView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
      [self setupSubViewsCorner:contentBgView corner:8];
      [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.leading.trailing.mas_equalTo(_theBgView).inset(20);
          make.height.mas_equalTo(DSize(200));
      }];
  }
  return _theBgView;
}
- (UIView *)theBottomButtonsView{
  if (!_theBottomButtonsView) {
    UIView * theView = [[UIView alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.theBgView);
      make.left.equalTo(self.theBgView);
      make.right.equalTo(self.theBgView);
      make.height.mas_equalTo(DSize(160));
    }];
//    UIView * theLineView1 = [[UIView alloc] init];
//    theLineView1.backgroundColor= [UIColor colorForHex:@"#F5F5F5"];
//    [theView addSubview:theLineView1];
//    [theLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.top.equalTo(theView);
//      make.left.equalTo(theView);
//      make.right.equalTo(theView);
//      make.height.mas_equalTo(1);
//    }];
//    UIView * theLineView2 = [[UIView alloc] init];
//    theLineView2.backgroundColor= [UIColor colorForHex:@"#F5F5F5"];
//    [theView addSubview:theLineView2];
//    [theLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.top.equalTo(theView);
//      make.bottom.equalTo(theView);
//      make.width.mas_equalTo(1);
//      make.centerX.equalTo(theView);
//    }];
    _theBottomButtonsView = theView;
  }
  return _theBottomButtonsView;
}
- (UIButton *)theCancelButton{
  if (!_theCancelButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theBottomButtonsView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(self.theBottomButtonsView).inset(20);
        make.height.mas_equalTo(DSize(76));
    }];
      [self setupSubViewsCorner:theView corner:4];
      theView.backgroundColor = RGBACOLOR(238, 242, 255, 1);
    [theView setTitle:ZCLocal(@"取消") forState:UIControlStateNormal];
    [theView setTitleColor:RGBACOLOR(70, 89, 156, 1) forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onCancelPress:) forControlEvents:UIControlEventTouchUpInside];
    _theCancelButton = theView;
  }
  return _theCancelButton;
}
- (UIButton *)theSureButton{
  if (!_theSureButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theBottomButtonsView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.theBottomButtonsView).inset(20);
        make.height.mas_equalTo(DSize(76));
        make.width.mas_equalTo(self.theCancelButton);
        make.leading.mas_equalTo(self.theCancelButton.mas_trailing).offset(10);
    }];
      [self setupSubViewsCorner:theView corner:4];
      theView.backgroundColor = RGBACOLOR(105, 132, 234, 1);
    [theView setTitle:ZCLocal(@"发送") forState:UIControlStateNormal];
    [theView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onSurePress:) forControlEvents:UIControlEventTouchUpInside];
    theView.enabled = false;
    _theSureButton = theView;
  }
  return _theSureButton;
}
- (UITextField *)theInputChatView{
  if (!_theInputChatView) {
    UITextField * theView = [[UITextField alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.theBgView).offset(DSize(50));
      make.leading.trailing.equalTo(self.theBgView).inset(DSize(50));
    }];
    theView.placeholder = ZCLocal(@"请填写发言内容");
    theView.delegate = self;
    theView.enabled = false;
    _theInputChatView = theView;
  }
  return _theInputChatView;
}
- (UILabel *)theTitleLabel{
  if (!_theTitleLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theBgView);
      make.top.equalTo(self.theBgView).offset(DSize(20));
    }];
    theView.text = @" ";
      theView.font = AutoPxFont(36);
    theView.textColor = [UIColor blackColor];
    _theTitleLabel = theView;
  }
  return _theTitleLabel;
}
- (UILabel *)theMessageLabel{
  if (!_theMessageLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.theBgView);
        make.top.equalTo(self.theTitleLabel.mas_bottom).offset(DSize(40));
      }];
    }];
    theView.text = ZCLocal(@"轮到你开始游戏了");
      theView.font = AutoPxFont(28);
    theView.textColor = [UIColor blackColor];
    _theMessageLabel = theView;
  }
  return _theMessageLabel;
}
- (UIScrollView *)theScrollView{
  if (!_theScrollView) {
    UIScrollView * theView = [[UIScrollView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.view);
      make.left.equalTo(self.view);
      make.right.equalTo(self.view);
      if (@available(iOS 11.0, *)) {
        make.height.mas_equalTo((DSize(80) + self.view.safeAreaInsets.bottom));
      } else {
        make.height.mas_equalTo(DSize(80));
      }
    }];
    [theView setBackgroundColor:[UIColor whiteColor]];
    _theScrollView = theView;
  }
  return _theScrollView;
}
@end
