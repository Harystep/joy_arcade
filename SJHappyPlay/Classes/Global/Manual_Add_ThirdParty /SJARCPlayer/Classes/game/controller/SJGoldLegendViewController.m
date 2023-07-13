#import "SJGoldLegendViewController.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPGamePlayerView.h"
#import "PPCloseButton.h"
#import "PPChatMessageView.h"
#import "PPGameMyMoneyView.h"
#import "PPUserInfoService.h"
#import "SJPushCoinGameControlView.h"
#import "PPGameControlView.h"
#import "SJPlayAlertViewController.h"
#import "PPStatisticalintegralView.h"
#import "PPHomeLiveRoomUnitDataModel.h"
#import "SJPlayAlertViewController.h"
#import "SJPCGameRuleRequestModal.h"
#import "PPImageAlertContentView.h"
#import "SJAlertInGameViewController.h"
#import "PPGoldLegendControlView.h"
#import "PPSaintGameControlButton.h"
#import "PPTcpMoveDirctionData.h"
#import "PPDefineAlertContentView.h"
#import "PPSaintGameValueView.h"
#import "PPChargeInGameView.h"
#import "PPCountDownView.h"
#import "SJPlayAlertViewController.h"
#import "PPGameConfig.h"

#import "AppDefineHeader.h"

#define GAME_MAX_COUNT_TIME 60
@interface SJGoldLegendViewController ()<SDChargeInGameViewDelegate>
@property (nonatomic, weak) PPGamePlayerView * theGamePlayerView;
@property (nonatomic, weak) PPCloseButton * theCloseButton;
@property (nonatomic, weak) PPChatMessageView * theChatMessageView;
@property (nonatomic, weak) PPGameMyMoneyView * theMyMoneyView;
@property (nonatomic, weak) SJPushCoinGameControlView * theGameControlView;
@property (nonatomic, weak) PPStatisticalintegralView * theStatisticalintegralView;
@property (nonatomic, weak) PPGoldLegendControlView * theGoldLegendControlView;
@property (nonatomic, assign) SDSaintLastPress lastPress;
@property (nonatomic, weak) PPSaintGameValueView * theGameCoinView;
@property (nonatomic, weak) PPSaintGameValueView * theGamePointView;
@property (nonatomic, assign) PPChargeInGameView * theChargeInGameView;
@property (nonatomic, strong) NSTimer * gameStopTimer;
@property (nonatomic, assign) NSInteger gameOverTimeValue;
@property (nonatomic, weak) PPCountDownView * theCountDownView;
@property (nonatomic, assign) BOOL currentAutoFire;
@property (nonatomic, assign) NSInteger currentGameSettlementPoint;
@end
@implementation SJGoldLegendViewController
@synthesize pullVideoView = _pullVideoView;
@synthesize playStatus = _playStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
  [self configView];
  [self configData];
}
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.theGamePlayerView mas_updateConstraints:^(MASConstraintMaker *make) {
    if (@available(iOS 11.0, *)) {
      make.top.equalTo(self.view).offset(self.view.safeAreaInsets.top);
    } else {
      make.top.equalTo(self.view).offset(20);
    }
  }];
  [[self theGameControlView] mas_updateConstraints:^(MASConstraintMaker *make) {
    if (@available(iOS 11.0, *)) {
      make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom);
    } else {
      make.bottom.equalTo(self.view);
    }
  }];
  [self.theMyMoneyView mas_updateConstraints:^(MASConstraintMaker *make) {
    if (@available(iOS 11.0, *)) {
      make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom - SF_Float(130));
    } else {
      make.bottom.equalTo(self.view).offset(- SF_Float(130));
    }
  }];
  [self.theGoldLegendControlView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view.mas_bottom).offset(SF_Float(-100) - self.view.safeAreaInsets.bottom);
  }];
}
- (void)dealloc {
  if (self.gameStopTimer) {
    [self.gameStopTimer invalidate];
    self.gameStopTimer = nil;
  }
}
#pragma mark - config
- (void)configView{
  [self pullVideoView];
  [self theCloseButton];
  [self theChatMessageView];
  [self theMyMoneyView];
  [self theGameControlView];
}
- (void)configData {
  @weakify_self;
  [[self theGameControlView].gameDoneSubject subscribeNext:^(id  _Nullable x) {
    @strongify_self;
    if ([x isKindOfClass:[NSNumber class]]) {
      NSInteger actionType = [x integerValue];
      DLog(@"[game done subject] ---> %ld", actionType);
      if (actionType == recharge) {
          [[PPGameConfig sharedInstance] goChargeForCoinInController:self];
      } else if (actionType == playStartGame) {
          if (self.viewModel) {
              if (self.theGameControlView.btStatus == cancelAppointmentAction) {
                [self.viewModel sendCancelAppointmentGameCmd];
              } else {
                [self.viewModel sendAppointmentGameCmd];
              }
          } else {
              [self dismissGameByNotAccountToken];
          }
      } else if (actionType == sendMessage) {
        [self showInputChat];
      }
    }
  }];
  self.currentAutoFire = false;
}
#pragma mark - set
- (void)setPlayStatus:(SDGamePlayStatues)playStatus {
  _playStatus = playStatus;
  switch (self.playStatus) {
    case SDGame_define:
      DLog(@"==========================================现在在空闲的状态==========================================");
      [self.theGameControlView definePlayGame];
      if (self.theGameControlView.btStatus != cancelAppointmentAction) {
        [self.theGameControlView setBtStatus:startAction];
      }
      self.theGameControlView.hidden = false;
      self.theGoldLegendControlView.hidden = true;
      self.theMyMoneyView.hidden = false;
      self.theChatMessageView.hidden = false;
      self.theStatisticalintegralView.hidden = true;
      self.theGamePlayerView.hidden = false;
      self.theGameCoinView.hidden = true;
      self.theGamePointView.hidden = true;
      [self.theCountDownView stopAnimation];
      [self.theCountDownView setHidden:true];
      break;
    case SDGame_selfPlaying:
      DLog(@"==========================================自己在玩游戏==========================================");
      self.theGameControlView.hidden = true;
      self.theGoldLegendControlView.hidden = false;
      self.theMyMoneyView.hidden = true;
      self.theChatMessageView.hidden = true;
      self.theStatisticalintegralView.hidden = false;
      self.theGamePlayerView.hidden = true;
      self.theGameCoinView.hidden = false;
      self.theGamePointView.hidden = false;
      break;
    case SDGame_otherPlaying:
      DLog(@"==========================================别的人在游戏中==========================================");
      [self.theGameControlView defineOtherPlayGame];
      if (self.theGameControlView.btStatus != cancelAppointmentAction) {
        [self.theGameControlView setBtStatus:appointmentAction];
      }
      self.theGameControlView.hidden = false;
      self.theGoldLegendControlView.hidden = true;
      self.theMyMoneyView.hidden = false;
      self.theChatMessageView.hidden = false;
      self.theStatisticalintegralView.hidden = true;
      self.theGamePlayerView.hidden = false;
      self.theGameCoinView.hidden = true;
      self.theGamePointView.hidden = true;
      [self.theCountDownView stopAnimation];
      [self.theCountDownView setHidden:true];
      break;
    default:
      break;
  }
}
static dispatch_once_t runonceToken;
static dispatch_once_t realseOnceToken;
- (void)setGameOverTimeValue:(NSInteger)gameOverTimeValue {
  _gameOverTimeValue = gameOverTimeValue;
  if (_gameOverTimeValue <= 0) {
    if (self.gameStopTimer) {
      [self.gameStopTimer invalidate];
      self.gameStopTimer = nil;
      [self.viewModel sendSaintSettlementCmd];
      self.lastPress = SDSaintLastPress_AFK;
    }
    return;
  }
  if (self.gameOverTimeValue < 45) {
    realseOnceToken = 0;
    dispatch_once(&runonceToken, ^{
      self.theCountDownView.countDownTime = self.gameOverTimeValue;
      self.theCountDownView.hidden = false;
      [[self theCountDownView] startAnimation];
    });
  } else {
    runonceToken = 0;
    dispatch_once(&realseOnceToken, ^{
      [self.theCountDownView stopAnimation];
      self.theCountDownView.hidden = true;
    });
  }
}
#pragma mark - action
- (void)onBackPress {
  if (self.playStatus == SDGame_selfPlaying) {
    [self showCloseGameAlert];
  } else {
    [self dismissGame];
  }
  self.lastPress = SDSaintLastPress_Close;
}
- (void)showCloseGameAlert {
  PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
  alertContentView.alertTitle = ZCLocal(@"退出游戏");
  alertContentView.alertMessage = ZCLocal(@"退出游戏进行结算～");
  SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
  [alertInGameViewController insertAlertContentView:alertContentView];
  [alertInGameViewController showAlertInViewController:self];
  @weakify_self;
  [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
    @strongify_self;
    NSInteger actionType = [x integerValue];
    if (actionType == SDAlertTypeSure) {
      if (self.playStatus == SDGame_selfPlaying) {
        [self.viewModel sendSaintSettlementCmd];
      } else {
        [self dismissGame];
      }
    }
  }];
}
- (void)showInputChat {
  SJPlayAlertViewController * chatController = [[SJPlayAlertViewController alloc] init];
  self.definesPresentationContext = YES;
  chatController.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  chatController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  chatController.alertShowType = SDAlertShowSendMessage;
  @weakify_self;
  chatController.inputChatBlock = ^(NSString *message) {
      @strongify_self;
      [self sendChatMessage:message];
  };
  [self presentViewController:chatController animated:NO completion:^{
  }];
}
- (void)sendChatMessage:(NSString * )message {
  NSString * sender = ZCLocal(@"我");
  PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
  chatModel.chatType = customMessage;
  chatModel.chatName = sender;
  chatModel.message = message;
  [self insertChatMessageToShow:chatModel];
  [self.viewModel sendChatMessage:message];
}
- (void)insertChatMessageToShow:(PPChatMessageDataModel *)chatModel {
  [self.theChatMessageView insertChatMessage:chatModel];
}
- (void)onTapChargeCoinPress:(id)sender {
  [self onChargePress];
}
- (void)onTapPointPress:(id)sender {
  [self onPointExchangePress];
}
#pragma mark - 开始倒计时，结束游戏的，60s 不动 ，自动退出游戏，结算游戏
- (void)startGameOverCountDown {
  if (self.gameStopTimer) {
    [self.gameStopTimer invalidate];
    self.gameStopTimer = nil;
  }
  if (self.currentAutoFire) {
    return;
  }
  @weakify_self;
  self.gameStopTimer = [NSTimer timerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
    @strongify_self;
    self.gameOverTimeValue -= 1;
  }];
  if (self.gameStopTimer) {
    [[NSRunLoop mainRunLoop] addTimer:self.gameStopTimer forMode:NSDefaultRunLoopMode];
  }
}
- (void)stopGameOverCountDown {
  if (self.gameStopTimer) {
    [self.gameStopTimer invalidate];
    self.gameStopTimer = nil;
  }
  runonceToken = 0;
  dispatch_once(&realseOnceToken, ^{
    [self.theCountDownView stopAnimation];
    self.theCountDownView.hidden = true;
  });
}
#pragma mark - 充值
- (void)onChargePress {
  if (_theChargeInGameView) {
    _theChargeInGameView = nil;
  }
  [self theChargeInGameView].chargeForMethod = SDChargeInGameForCoin;
  self.theChargeInGameView.currentPriceValue = [PPUserInfoService get_Instance].goldCoin;
  self.theChargeInGameView.chargeList = self.viewModel.chargeOptionList;
  [self.theChargeInGameView showChargeInGame];
}
#pragma mark - 积分兑换
- (void)onPointExchangePress {
  if (_theChargeInGameView) {
    _theChargeInGameView = nil;
  }
  [self theChargeInGameView].chargeForMethod = SDChargeInGameForCoinByPoint;
  self.theChargeInGameView.currentPriceValue = [PPUserInfoService get_Instance].goldCoin;
  self.theChargeInGameView.currentPointValue = [PPUserInfoService get_Instance].points;
  self.theChargeInGameView.chargeList = self.viewModel.pmPointList;
  [self.theChargeInGameView showChargeInGame];
}
#pragma mark - SDGameViewModelDelegate
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo {
  [self.pullVideoView loginRoomId:roomInfo.liveRoomCode];
  [self.pullVideoView loadFirstStreamDefaultImageUrl:roomInfo.gameUrl];
  [self.pullVideoView loadLastStreamDefaultImageUrl:roomInfo.profileUrl];
  self.theGameControlView.gamePrice = roomInfo.price;
  self.theStatisticalintegralView.type = self.viewModel.type;
}
- (void)updateUserInfo {
  if (_theChargeInGameView) {
    self.theChargeInGameView.currentPriceValue = [PPUserInfoService get_Instance].goldCoin;
    self.theChargeInGameView.currentPointValue = [PPUserInfoService get_Instance].points;
  }
  self.theMyMoneyView.priceValue = [PPUserInfoService get_Instance].goldCoin;
  self.theGameCoinView.gameValue = [[PPUserInfoService get_Instance].goldCoin integerValue];
  self.theGamePointView.gameValue = [[PPUserInfoService get_Instance].points integerValue];
}
- (void)changeWaitPlayer:(NSArray<SDPlayerInfoModel *> *)list {
  [self.theGamePlayerView setWaitPlayerList:list];
}
- (void)setCurrentPlayer:(SDPlayerInfoModel *)player {
  [self.theGamePlayerView setCurrentPlayer:player];
}
- (void)changeGameMemberCount:(NSInteger)memberCount {
  [self.theGamePlayerView setWaitMemberCount:memberCount];
}
- (void)changeGameStartPlayBtStatus:(GameButtonStatus)btStatus {
  DLog(@"[changeGameStartPlayBtStatus] ---> %ld", btStatus);
  [self.theGameControlView setBtStatus:btStatus];
}
- (void)changeGameStatus:(NSInteger)gameStatus {
  self.playStatus = gameStatus;
}
- (void)changeGameAppointmentCount:(NSInteger)appointmentCount {
  self.theGameControlView.appointmentCount = appointmentCount;
}
- (void)startGameWithCounDownTime:(NSInteger)cdTime {
  if (cdTime != 0) {
    self.gameOverTimeValue = cdTime;
  } else {
    self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
  }
  self.currentGameSettlementPoint = 0;
  [self startGameOverCountDown];
}
- (void)restartCountDownTimerForPushCoinDevice {
}
- (void)recevicePushCoin:(NSString * )coin {
  self.theStatisticalintegralView.integralValue = [coin integerValue];
}
- (void)showSaintSettlementResult:(NSString *)settlement {
  if (self.lastPress == SDSaintLastPress_AFK) {
   [self.viewModel sendSaintArcadeDownCmd];
  }
  if (settlement) {
    NSInteger settlementValue = [settlement integerValue];
    self.currentGameSettlementPoint += settlementValue;
    self.theStatisticalintegralView.integralValue = self.currentGameSettlementPoint;
    PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
    alertContentView.alertTitle = @"结算";
    alertContentView.alertMessage = [NSString stringWithFormat:@"结算结果：%@积分", settlement];
    SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
    [alertInGameViewController insertAlertContentView:alertContentView];
//    alertInGameViewController.dismissCloseButton = true;
    [alertInGameViewController showAlertInViewController:self];
    @weakify_self;
    [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      if (self.lastPress == SDSaintLastPress_Close) {
        [self dismissGame];
      }
    }];
  } else {
    PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
    alertContentView.alertTitle = @"结算";
    alertContentView.alertMessage = @"结算结果：0积分";
    SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
    [alertInGameViewController insertAlertContentView:alertContentView];
//    alertInGameViewController.dismissCloseButton = true;
    [alertInGameViewController showAlertInViewController:self];
    @weakify_self;
    [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      if (self.lastPress == SDSaintLastPress_Close) {
        [self dismissGame];
      }
    }];
  }
}
- (void)showGameTurnFromTCP:(PPTcpReceviceData *)receviceData {
  SJPlayAlertViewController * chatController = [[SJPlayAlertViewController alloc] init];
  chatController.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  chatController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  chatController.alertShowType = SDAlertShowAppmentPlay;
  chatController.waitSeconds = receviceData.waitSeconds;
  @weakify_self;
  chatController.alertBlock = ^(int type) {
    @strongify_self;
    if (type == 1) {
      [self.viewModel sendStartGameCmd];
    }else {
      [self.viewModel sendAppointmentGameCmd];
    }
  };
  [self presentViewController:chatController animated:NO completion:^{
  }];
}
#pragma mark - SDChargeInGameViewDelegate
- (void)dissmissChargeController {
  _theChargeInGameView = nil;
}
#pragma mark - lazy UI
- (SJPullVideoView * )pullVideoView{
  if (!_pullVideoView) {
    SJPullVideoView * theView = [[SJPullVideoView alloc] init];
    theView.machineSn = self.machineSn;
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    theView.pullViewForDevice = SDPullViewForGoldLegend;
    [theView displayVideoViewForFit];
    _pullVideoView = theView;
  }
  return _pullVideoView;
}
- (PPGamePlayerView * )theGamePlayerView{
  if (!_theGamePlayerView) {
    PPGamePlayerView * theView = [[PPGamePlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - SF_Float(93), SF_Float(72))];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.top.equalTo(self.view).offset(20);
      make.size.mas_equalTo(theView.frame.size);
    }];
    _theGamePlayerView = theView;
  }
  return _theGamePlayerView;
}
- (PPCloseButton * )theCloseButton{
  if (!_theCloseButton) {
    PPCloseButton * theView = [[PPCloseButton alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.theGamePlayerView.mas_centerY);
      make.size.mas_equalTo(theView.frame.size);
      make.right.equalTo(self.view.mas_right).offset(SF_Float(-20));
    }];
    [theView addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
    _theCloseButton = theView;
  }
  return _theCloseButton;
}
- (PPChatMessageView * )theChatMessageView{
  if (!_theChatMessageView) {
    PPChatMessageView * theView = [[PPChatMessageView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view).offset(SF_Float(30));
      make.size.mas_equalTo(theView.frame.size);
      make.top.equalTo(self.theGamePlayerView.mas_bottom).offset(SF_Float(838));
    }];
    _theChatMessageView = theView;
  }
  return _theChatMessageView;
}
- (PPGameMyMoneyView * )theMyMoneyView{
  if (!_theMyMoneyView) {
    PPGameMyMoneyView * theView = [[PPGameMyMoneyView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.size.mas_equalTo(theView.frame.size);
      make.bottom.equalTo(self.view).offset(DSize(-130));
    }];
    [theView chagnePushCoinModel];
    _theMyMoneyView = theView;
  }
  return _theMyMoneyView;
}
- (SJPushCoinGameControlView * )theGameControlView{
  if (!_theGameControlView) {
    SJPushCoinGameControlView * theView = [[SJPushCoinGameControlView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.bottom.equalTo(self.view);
      make.size.mas_equalTo(theView.frame.size);
    }];
    theView.maxCountDownTime = GAME_MAX_COUNT_TIME;
    _theGameControlView = theView;
  }
  return _theGameControlView;
}
- (PPStatisticalintegralView * )theStatisticalintegralView{
  if (!_theStatisticalintegralView) {
    PPStatisticalintegralView * theView = [[PPStatisticalintegralView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(theView.frame.size);
      make.centerX.equalTo(self.view);
      make.bottom.equalTo(self.theGoldLegendControlView.mas_bottom).offset(-SF_Float(272));
    }];
    theView.hidden = true;
    @weakify_self;
    [theView.offPlaneSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      [self.viewModel sendSaintSettlementCmd];
    }];
    _theStatisticalintegralView = theView;
  }
  return _theStatisticalintegralView;
}
- (PPGoldLegendControlView * )theGoldLegendControlView{
  if (!_theGoldLegendControlView) {
    PPGoldLegendControlView * theView = [[PPGoldLegendControlView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.right.equalTo(self.view);
      make.height.mas_equalTo(SF_Float(763));
      make.bottom.equalTo(self.view.mas_bottom).offset(SF_Float(-100));
    }];
    theView.hidden = true;
    @weakify_self;
    [theView.simpleControlSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      NSInteger actionType = [x integerValue];
      if (actionType == goldLegendControl_pushCoin) {
        [self.viewModel sendSaintCoinInWithisNewGame:true];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      } else if (actionType == goldLegendControl_fireDouble) {
        [self.viewModel sendSaintRaisebt];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      } else if (actionType == goldLegendControl_fireLock) {
        [self.viewModel sendGoldLegendFireLockCmd];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      } else if (actionType == goldLegendControl_fireAuto) {
        [self.viewModel sendGoldLegendFireAutoCmd];
        [self stopGameOverCountDown];
        self.currentAutoFire = true;
      } else if (actionType == goldLegendControl_fireSimple) {
        self.currentAutoFire = false;
        [self.viewModel sendSaintSimpleFirCmd];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      }
    }];
    [theView.controlLeftSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      NSInteger actionType = [x integerValue];
      if (actionType == ControlTouchDown) {
        [self.viewModel sendSaintMoveStartWithDirction:SDMoveDirctionLeft];
        [self stopGameOverCountDown];
      } else if (actionType == ControlTouchUp) {
        [self.viewModel sendSaintMoveEndWithDirction:SDMoveDirctionLeft];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      } else if (actionType == ControlTouchSimple) {
        [self.viewModel sendSaintMoveSimpleWithDirction:SDMoveDirctionLeft];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      }
    }];
    [theView.controlRightSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      NSInteger actionType = [x integerValue];
      if (actionType == ControlTouchDown) {
        [self.viewModel sendSaintMoveStartWithDirction:SDMoveDirctionRight];
        [self stopGameOverCountDown];
      } else if (actionType == ControlTouchUp) {
        [self.viewModel sendSaintMoveEndWithDirction:SDMoveDirctionRight];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      } else if (actionType == ControlTouchSimple) {
        [self.viewModel sendSaintMoveSimpleWithDirction:SDMoveDirctionRight];
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
        [self startGameOverCountDown];
      }
    }];
    _theGoldLegendControlView = theView;
  }
  return _theGoldLegendControlView;
}
- (PPSaintGameValueView * )theGameCoinView{
  if (!_theGameCoinView) {
    PPSaintGameValueView * theView = [[PPSaintGameValueView alloc] initWithForGoldLegendValueType:SDGameValue_Coin];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(theView.frame.size.width);
      make.height.mas_equalTo(theView.frame.size.height);
      make.left.equalTo(self.view).offset(SF_Float(22));
      make.centerY.equalTo(self.theCloseButton.mas_centerY);
    }];
    [theView addTarget:self action:@selector(onTapChargeCoinPress:) forControlEvents:UIControlEventTouchUpInside];
    theView.hidden = true;
    _theGameCoinView = theView;
  }
  return _theGameCoinView;
}
- (PPSaintGameValueView * )theGamePointView{
  if (!_theGamePointView) {
    PPSaintGameValueView * theView = [[PPSaintGameValueView alloc] initWithForGoldLegendValueType:SDGameValue_point];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theGameCoinView.mas_right).offset(SF_Float(20));
      make.width.mas_equalTo(theView.frame.size.width);
      make.height.mas_equalTo(theView.frame.size.height);
      make.centerY.equalTo(self.theCloseButton.mas_centerY);
    }];
    [theView addTarget:self action:@selector(onTapPointPress:) forControlEvents:UIControlEventTouchUpInside];
    theView.hidden = true;
    _theGamePointView = theView;
  }
  return _theGamePointView;
}
- (PPChargeInGameView * )theChargeInGameView{
  if (!_theChargeInGameView) {
    PPChargeInGameView * theView = [[PPChargeInGameView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    theView.delegate = self;
    @weakify_self;
    [theView.chargetSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      if ([x isKindOfClass:[PPChargetCoinData class]]) {
        PPChargetCoinData * chargetData = x;
        if (chargetData.type == 10) {
          PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
          alertContentView.alertTitle = @"确定兑换";
          alertContentView.alertMessage = [NSString stringWithFormat:@"确定使用%@积分兑换%@金币吗", chargetData.chargePrice, chargetData.coinCount];
          SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
          [alertInGameViewController insertAlertContentView:alertContentView];
          [alertInGameViewController showAlertInViewController:self];
          @weakify_self;
          [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            NSInteger actionType = [x integerValue];
            if (actionType == SDAlertTypeSure) {
              [self.viewModel chargeByPoint:chargetData];
            }
          }];
        } else {
//          [self.viewModel chargetByApple:chargetData];
            [self.viewModel chargeByAli:chargetData];
        }
      }
    }];
    _theChargeInGameView = theView;
  }
  return _theChargeInGameView;
}
- (PPCountDownView * )theCountDownView{
  if (!_theCountDownView) {
    PPCountDownView * theView = [[PPCountDownView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.view).offset(-SF_Float(9));
      make.size.mas_equalTo(theView.frame.size);
      make.bottom.equalTo(self.theGoldLegendControlView.mas_bottom).offset(-SF_Float(90));
    }];
    theView.maxCountDownTime = GAME_MAX_COUNT_TIME;
    theView.hidden = true;
    _theCountDownView = theView;
  }
  return _theCountDownView;
}
@end
