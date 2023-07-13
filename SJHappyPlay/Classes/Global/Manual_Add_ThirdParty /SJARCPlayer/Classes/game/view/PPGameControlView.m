#import "PPGameControlView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "PPGamePlayControlView.h"
#import "POP.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"


@interface PPGameControlView ()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) UIButton * theSendMessageButton;
@property (nonatomic, weak) UIButton * theRechargeButton;
@property (nonatomic, weak) PPGameStartButton * theGameButton;
@property (nonatomic, weak) PPGamePlayControlView * theGameControlView;
@property (nonatomic, weak) UIView * theControlView;
@property (nonatomic, assign) NSTimeInterval wawajiEndGameTime;
@property (nonatomic, assign) BOOL isGaming;

@property (nonatomic, assign) SDGameType gameType;

@end
@implementation PPGameControlView
- (instancetype)initWithType:(SDGameType)type
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(288));
      self.gameType = type;
    [self configView];
  }
  return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
      self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(288));
        self.gameType = game_type_wawaji;
      [self configView];
    }
    return self;
}
#pragma mark - config
- (void)configView {
  [self theBgImageView];
  [self theSendMessageButton];
  [self theRechargeButton];
  [self theGameButton].btStatus = startAction;
  self.gameDoneSubject = [RACSubject subject];
  self.longTouchActionSubject = [RACSubject subject];
  self.longTouchEndSubject = [RACSubject subject];
  self.catchActionSubject = [RACSubject subject];
}
#pragma mark - set
- (void)setGamePrice:(NSString *)gamePrice {
  _gamePrice = gamePrice;
  self.theGameButton.gamePrice = self.gamePrice;
}
- (void)setBtStatus:(GameButtonStatus)btStatus {
  _btStatus = btStatus;
  DLog(@"[修改当前的 显示的 状态] -> %ld", self.btStatus);
  [self theGameButton].btStatus = btStatus;
}
- (void)setCountDownTime:(NSInteger)countDownTime {
  _countDownTime = countDownTime;
  self.wawajiEndGameTime = [[NSDate date] timeIntervalSince1970] * 1000 + self.countDownTime;
  self.theGameControlView.countDownTime = countDownTime;
}
- (void)setAppointmentCount:(NSInteger)appointmentCount {
  _appointmentCount = appointmentCount;
  DLog(@"[appointment] -> count = %ld", appointmentCount);
  self.theGameButton.appointmentCount = appointmentCount;
  if (self.btStatus != selfGamingAction) {
  }
  if (!self.isGaming) {
    if (self.btStatus != cancelAppointmentAction) {
      if (self.appointmentCount > 0) {
        [self.theGameButton showAppointmentInfo];
      } else if (self.appointmentCount == 0) {
        self.btStatus = startAction;
      }
    }
  }
}
#pragma mark - public method
- (void)startToPlayGame {
  POPBasicAnimation * hideAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
  hideAnimation.toValue = @(0);
  [self.theControlView pop_addAnimation:hideAnimation forKey:@"hide_animation_key"];
  POPBasicAnimation * showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
  showAnimation.toValue = @(1);
  showAnimation.beginTime = CACurrentMediaTime() + 0.3;
  [self.theGameControlView pop_addAnimation:showAnimation forKey:@"show_animation_key"];
  self.isGaming = true;
  [[self theGameControlView] startWawajiGame];
}
- (void)definePlayGame {
  self.theControlView.alpha = 1;
  self.theGameControlView.alpha = 0;
  self.isGaming = false;
  self.btStatus = selfGamingAction;
}
- (void)defineOtherPlayGame{
  [self definePlayGame];
  self.isGaming = true;
}
- (void)appWillEnterForeground {
  if (self.theGameControlView.countDownTime > 0) {
    NSInteger diff =self.wawajiEndGameTime - [[NSDate date] timeIntervalSince1970] * 1000;
    if (diff > 0) {
      self.theGameControlView.countDownTime = diff;
    }
  }
}
#pragma mark - action
- (void)onSendMessagePress:(UIControl *) sender {
  [self.gameDoneSubject sendNext: @(sendMessage)];
}
- (void)onRechargePress:(UIControl *)sender {
  [self.gameDoneSubject sendNext: @(recharge)];
}
- (void)onGameStartPress:(UIControl *)sender {
  [self.gameDoneSubject sendNext: @(playStartGame)];
}
#pragma mark - lazy UI
- (UIImageView * )theBgImageView{
  if (!_theBgImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_control_bg"]];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    _theBgImageView = theView;
  }
  return _theBgImageView;
}
- (UIView * )theControlView{
  if (!_theControlView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    _theControlView = theView;
  }
  return _theControlView;
}
- (UIButton * )theSendMessageButton{
  if (!_theSendMessageButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theControlView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theControlView).offset(SF_Float(63));
      make.top.equalTo(self.theControlView).offset(SF_Float(54));
      make.width.mas_equalTo(SF_Float(116));
      make.height.mas_equalTo(SF_Float(113));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"img_dbj_msg_a"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onSendMessagePress:) forControlEvents:UIControlEventTouchUpInside];
    _theSendMessageButton = theView;
  }
  return _theSendMessageButton;
}
- (UIButton * )theRechargeButton{
  if (!_theRechargeButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theControlView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.theControlView.mas_right).offset(-SF_Float(63));
      make.top.equalTo(self.theControlView).offset(SF_Float(54));
      make.width.mas_equalTo(SF_Float(116));
      make.height.mas_equalTo(SF_Float(113));
    }];
      if (self.gameType == game_type_wawaji) {//img_dbj_recharge_a   img_dbj_msg_a
          [theView setImage:[PPImageUtil imageNamed:@"img_dbj_recharge_a"] forState:UIControlStateNormal];
      } else {
          [theView setImage:[PPImageUtil imageNamed:@"ico_recharge_bt"] forState:UIControlStateNormal];
      }
    [theView addTarget:self action:@selector(onRechargePress:) forControlEvents:UIControlEventTouchUpInside];
    _theRechargeButton = theView;
  }
  return _theRechargeButton;
}
- (PPGameStartButton * )theGameButton{
  if (!_theGameButton) {
    PPGameStartButton * theView = [[PPGameStartButton alloc] init];
    [self.theControlView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theControlView);
      make.width.mas_equalTo(SF_Float(268));
      make.height.mas_equalTo(SF_Float(130));
      make.top.equalTo(self.theControlView).offset(SF_Float(45));
    }];
    theView.startGameImage = [PPImageUtil imageNamed:@"img_dbj_start_bg_a"];
    theView.appointmentImage = [PPImageUtil imageNamed:@"img_dbj_start_bg_a"];//ico_start_game_bt
    theView.cancelAppointmentImage = [PPImageUtil imageNamed:@"img_dbj_start_bg_a"];//ico_cancel_appointment_bt
    [theView addTarget:self action:@selector(onGameStartPress:) forControlEvents:UIControlEventTouchUpInside];
    _theGameButton = theView;
  }
  return _theGameButton;
}
- (PPGamePlayControlView * )theGameControlView{
  if (!_theGameControlView) {
    PPGamePlayControlView * theView = [[PPGamePlayControlView alloc] initWithFrame:self.bounds];
    [self addSubview:theView];
    theView.longTouchEndSubject = self.longTouchEndSubject;
    theView.longTouchActionSubject = self.longTouchActionSubject;
    theView.catchActionSubject = self.catchActionSubject;
    theView.alpha = 0;
    _theGameControlView = theView;
  }
  return _theGameControlView;
}
@end
