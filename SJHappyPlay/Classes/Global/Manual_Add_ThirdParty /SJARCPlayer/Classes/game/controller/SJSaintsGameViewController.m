#import "SJSaintsGameViewController.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPWaitPlayerView.h"
#import "PPTcpReceviceData.h"
#import "PPGameMoreFunctionView.h"
#import "PPGameActionMoreModel.h"
#import "PPHomeLiveRoomUnitDataModel.h"
#import "PPSaintPlayerWaitView.h"
#import "PPSaintPlayerControlView.h"
#import "PPSaintPostionPlayingView.h"
#import "PPChargeInGameView.h"
#import "PPUserInfoService.h"
#import "SJAlertInGameViewController.h"
#import "PPDefineAlertContentView.h"
#import "SJPCGameRuleRequestModal.h"
#import "PPImageAlertContentView.h"
#import "PPCloseButton.h"
#import "PPSaintGameValueView.h"
#import "PPImageUtil.h"
#import "PPNetworkConfig.h"
#import "SJGuidViewController.h"
#import "PPUserInfoService.h"
#import "UIView+Toast.h"
#import "AppDefineHeader.h"

#import "SDRechargeWebViewController.h"
#import "SJRequestGameRoomListModel.h"
#import "SJResponseGameRoomListModel.h"
#import "SJChangeRoomListAlertView.h"
#import "SJRequestUserEnterRoomModel.h"
#import "SJResponseUserEnterRoomModel.h"
#import "NSString+MJExtension.h"
#import "SJGameRoomListInfoModel.h"

#define GAME_MAX_COUNT_TIME 60
@interface SJSaintsGameViewController ()<SDChargeInGameViewDelegate, SJChangeRoomListAlertViewDelegate>
@property (nonatomic, weak) PPSaintPlayerWaitView * theSaintPlayerWaitView;//角色操作
@property (nonatomic, weak) PPSaintPlayerControlView * theSaintPlayControllView;
@property (nonatomic, weak) PPSaintPostionPlayingView * theSaintPostionPlayingView;//角色信息
@property (nonatomic, strong) NSTimer * gameStopTimer;
@property (nonatomic, weak) UILabel * theGameOverCountDownLabel;
@property (nonatomic, assign) SDSaintLastPress lastPress;
@property (nonatomic, assign) NSInteger gameOverTimeValue;
@property (nonatomic, assign) PPChargeInGameView * theChargeInGameView;
@property (nonatomic, weak) PPCloseButton * theCloseButton;
@property (nonatomic, weak) UIButton * theGameRuleButton;
@property (nonatomic, weak) UIButton * theGameRechargeButton;
@property (nonatomic, weak) UIButton * theGameExchangeButton;
@property (nonatomic, weak) UIButton * theGameChangeRoomButton;
@property (nonatomic, weak) PPSaintGameValueView * theGameCoinView;
@property (nonatomic, weak) PPSaintGameValueView * theGamePointView;
@property (nonatomic,strong) UIView *coinContentBgView;
@property (nonatomic,strong) SJChangeRoomListAlertView *roomListView;

@end
@implementation SJSaintsGameViewController
@synthesize pullVideoView = _pullVideoView;
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configView];
    [self configData];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)dealloc {
    if (self.gameStopTimer) {
        [self.gameStopTimer invalidate];
        self.gameStopTimer = nil;
    }
}
- (BOOL)shouldAutorotate {
    return true;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)prefersHomeIndicatorAutoHidden {
    return true;
}
#pragma mark - config
- (void)configView {
    self.view.backgroundColor = [UIColor blackColor];
    [self pullVideoView];
    [self theSaintPostionPlayingView];
    [self theSaintPlayerWaitView];
    [self theCloseButton];
    [self theGameChangeRoomButton];
    [self theGameExchangeButton];
    [self theGameRechargeButton];
    [self theGameRuleButton];
    [self coinContentBgView];
}
- (void)configData {       
    NSLog(@"content:%@", ZCLocal(@"确认"));
    @weakify_self;
    [self.theSaintPlayerWaitView.playerDoneSubject subscribeNext:^(id  _Nullable x) {
        NSInteger sanitPlayerIndex = [x integerValue];
        @strongify_self;
        if (self.viewModel) {
            [self.viewModel sendOperateCmdWithPostion:sanitPlayerIndex];
        } else {
            [self dismissGameByNotAccountToken];
        }
    }];
}
#pragma mark - set
- (void)setGameOverTimeValue:(NSInteger)gameOverTimeValue {
    _gameOverTimeValue = gameOverTimeValue;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_gameOverTimeValue <= 0) {
            if (self.gameStopTimer) {
                [self.gameStopTimer invalidate];
                self.gameStopTimer = nil;
                [self.viewModel sendSaintSettlementCmd];
                self.lastPress = SDSaintLastPress_AFK;
            }
            self.theGameOverCountDownLabel.hidden = true;
            return;
        }
        if (self.gameOverTimeValue < 45) {
            self.theGameOverCountDownLabel.hidden = false;
            self.theGameOverCountDownLabel.text = [NSString stringWithFormat:@"自动结算: %lds",self.gameOverTimeValue];
        } else {
            self.theGameOverCountDownLabel.hidden = true;
        }
    });
}
- (void)setLastPress:(SDSaintLastPress)lastPress {
    _lastPress = lastPress;
}
#pragma mark - action
- (void)onGameMoreAction:(PPGameActionMoreModel * )actionModel {
    switch (actionModel.actionType) {
        case gameActionCoin:
            [self onCoinInPress];
            self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
            [self startGameOverCountDown];
            self.lastPress = SDSaintLastPress_PushCoin;
            break;
        case gameActionCharge:
            [self onChargePress];
            break;
        case gameActionExchagne:
            [self onPointExchangePress];
            break;
        case gameActionSettlement:
            [self onSaintSettlementPress];
            self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
            [self startGameOverCountDown];
            break;
        case gameActionExit:
            [self onBackPress];
            self.lastPress = SDSaintLastPress_Close;
            break;
        case gameActionRule: {
            [self showRulePress];
        }
        default:
            break;
    }
}
- (void)onCloseGamePress:(id)sender {
    [self onBackPress];
    self.lastPress = SDSaintLastPress_Close;
}

- (void)onTapGameChangeroomPress:(id)sender {
    [self showChangeRoomPress];
}
- (void)onTapGameRulePress:(id)sender {
    [self showRulePress];
}
- (void)onTapGameRechargePress:(id)sender {
    [self onChargePress];
}
- (void)onTapChargeCoinPress:(id)sender {
    [self onChargePress];
}
- (void)onTapPointPress:(id)sender {
    [self onPointExchangePress];
}

- (void)showChangeRoomPress {
    SJRequestGameRoomListModel *requestModel = [[SJRequestGameRoomListModel alloc] init];
    requestModel.roomId = self.room_id;
    requestModel.machineType = @"4";
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if(!error) {
            SJResponseGameRoomListModel *dataModel = (SJResponseGameRoomListModel *)responseModel;
            NSLog(@"%@", dataModel);
            [self showGameRoomListView:dataModel.data];
        }
    }];
}

- (void)showGameRoomListView:(NSArray *)roomList {
    [self.view addSubview:self.roomListView];
    [self.roomListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.roomListView.hidden = NO;
    self.roomListView.delegate = self;
    self.roomListView.roomList = roomList;
    @weakify_self;
    self.roomListView.viewClickBlock = ^{
        weakSelf.roomListView.hidden = YES;
    };
}

- (void)showRulePress{
    @weakify_self;
    SJPCGameRuleRequestModal * requestModal = [[SJPCGameRuleRequestModal alloc] init];
    requestModal.machineSn = self.viewModel.machineSn;
    [requestModal requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if (!error) {
            @strongify_self;
            SJPCGameRuleResponseModal * gameRule = (SJPCGameRuleResponseModal * )responseModel;
            NSString * rule = gameRule.data.rule;
            PPImageAlertContentView * alertContentView = [[PPImageAlertContentView alloc] init];
            alertContentView.imageUrl = rule;
            SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
            [alertInGameViewController insertAlertContentView:alertContentView];
            alertInGameViewController.dismissSureButton = true;
            [alertInGameViewController showAlertInViewController:self];
        }
    }];
}
- (void)showGameGuid {
    if ([[PPUserInfoService get_Instance] checkShowGuid]) {
        CGRect fireButtonFrame = [self.theSaintPlayControllView convertRect:self.theSaintPlayControllView.thePushCoinButton.frame toView:self.view];
        NSLog(@"[fire] ----> %f, %f,%f,%f",fireButtonFrame.origin.x, fireButtonFrame.origin.y, fireButtonFrame.size.width, fireButtonFrame.size.height);
        SJGuidViewController * guidViewController = [[SJGuidViewController alloc] init];
        guidViewController.fireFrame = fireButtonFrame;
        self.definesPresentationContext = true;
        guidViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        guidViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:guidViewController animated:false completion:nil];
    }
}
#pragma mark - 投币
- (void)onCoinInPress {
    if (self.lastPress == SDSaintLastPress_Settlement) {
        [self.viewModel sendSaintCoinInWithisNewGame:true];
    } else {
        [self.viewModel sendSaintCoinInWithisNewGame:false];
    }
    self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
    [self startGameOverCountDown];
    self.lastPress = SDSaintLastPress_PushCoin;
}
- (void)onCoinInPressWithCount:(NSInteger)count {
    if (self.lastPress == SDSaintLastPress_Settlement) {
        [self.viewModel sendSaintCoinInWithisNewGame:true andCoinCount:count];
    } else {
        [self.viewModel sendSaintCoinInWithisNewGame:false andCoinCount:count];
    }
    self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
    [self startGameOverCountDown];
    self.lastPress = SDSaintLastPress_PushCoin;
}
#pragma mark - 充值
- (void)onChargePress {
    if (_theChargeInGameView) {
        _theChargeInGameView = nil;
    }
    [self theChargeInGameView].chargeForMethod = SDChargeInGameForCoin;
    self.theChargeInGameView.currentPriceValue = [PPUserInfoService get_Instance].goldCoin;
    self.theChargeInGameView.currentPointValue = [PPUserInfoService get_Instance].points;
    self.theChargeInGameView.currentStoneValue = [PPUserInfoService get_Instance].money;
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
    self.theChargeInGameView.currentStoneValue = [PPUserInfoService get_Instance].money;
    self.theChargeInGameView.chargeList = self.viewModel.pmPointList;
    [self.theChargeInGameView showChargeInGame];
}
#pragma mark - 结算
- (void)onSaintSettlementPress {
    self.lastPress = SDSaintLastPress_Settlement;
    [self.viewModel sendSaintSettlementCmd];
    [self.theSaintPlayControllView endTouchAction];
}
#pragma mark - 退出
- (void)onBackPress {
    if (self.lastPress == SDSaintLastPress_Settlement) {
        [self dismissGame];
        return;
    }
    if (self.viewModel.saintPlayerIndex > 0) {
        [self showCloseGameAlert];
    } else {
        [self dismissGame];
    }
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
            if (self.viewModel.saintPlayerIndex > 0) {
                [self.viewModel sendSaintSettlementCmd];
            } else {
                [self dismissGame];
            }
        }
    }];
}
#pragma mark - select room
- (void)disSelectIntoRoom:(SJGameRoomListInfoModel *)model {
    if (self.viewModel.saintPlayerIndex > 0) {
        [self.view makeToast:@"游戏进行中，暂不支持换房间"];
    } else {
        [self.viewModel leaveRoom];
        [self.pullVideoView leaveRoom];
        @weakify_self;
        SJRequestUserEnterRoomModel * requestModal = [[SJRequestUserEnterRoomModel alloc] init];
        requestModal.roomId = model.roomId;
        requestModal.accessToken = [PPUserInfoService get_Instance].access_token;
        [requestModal requestFinish:^(__kindof SJResponseUserEnterRoomModel * _Nullable responseModel, PPError * _Nullable error) {
            @strongify_self;
            if (!error) {
                if([responseModel.errCode integerValue] == 0) {//更新数据
                    [self.viewModel.userInfoCommand execute:nil];
                    [self enterNewRoom:model];
                }
            }
        }];
    }
}

- (void)enterNewRoom:(SJGameRoomListInfoModel *)model {
    NSLog(@"%@-%@", model.machineSn, model.roomId);
    [self enterNewRoom:model.machineSn room_id:model.roomId];
}

#pragma mark - 开始倒计时，结束游戏的，60s 不动 ，自动退出游戏，结算游戏
- (void)startGameOverCountDown {
    if (self.gameStopTimer) {
        [self.gameStopTimer invalidate];
        self.gameStopTimer = nil;
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
}
#pragma mark - SDGameViewModelDelegate
- (void)updateUserInfo {
    if (_theChargeInGameView) {
        _theChargeInGameView.currentPriceValue = [PPUserInfoService get_Instance].goldCoin;
        _theChargeInGameView.currentPointValue = [PPUserInfoService get_Instance].points;
        _theChargeInGameView.currentStoneValue = [PPUserInfoService get_Instance].money;
    }
    NSLog(@"coin:%@ zhuanshi:%@", [PPUserInfoService get_Instance].goldCoin, [PPUserInfoService get_Instance].money);
    self.theGameCoinView.gameValue = [[PPUserInfoService get_Instance].goldCoin integerValue];
    self.theGamePointView.gameValue = [[PPUserInfoService get_Instance].points integerValue];
}
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo {
    [self.pullVideoView loginRoomId:roomInfo.liveRoomCode];
    [self.pullVideoView loadFirstStreamDefaultImageUrl:roomInfo.gameUrl];
    [self.pullVideoView loadLastStreamDefaultImageUrl:roomInfo.profileUrl];
}
- (void)changeGameMemberCount:(NSInteger)memberCount {
}
- (void)changeWaitPlayer:(NSArray<SDPlayerInfoModel *> *)list {
}
- (void)startGameWithCounDownTime:(NSInteger)cdTime {
    self.theSaintPlayerWaitView.hidden = true;
    self.theSaintPlayControllView.hidden = false;
    if (cdTime != 0) {
        self.gameOverTimeValue = cdTime;
    } else {
        self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
    }
    [self startGameOverCountDown];
    self.pullVideoView.staint_index = self.viewModel.saintPlayerIndex;
    [self showGameGuid];
}
- (void)changeSaintPlayerSeat {
    self.theSaintPostionPlayingView.playerList = self.viewModel.seats;
    self.theSaintPlayerWaitView.playerList = self.viewModel.seats;
}
- (void)changeGameStatus:(NSInteger)gameStatus {
    self.playStatus = gameStatus;
    if (self.playStatus == SDGame_define || self.playStatus == SDGame_otherPlaying) {
        self.theSaintPlayerWaitView.hidden = false;
        self.theSaintPlayControllView.hidden = true;
    }
}
- (void)showSaintSettlementResult:(NSString *)settlement {
    if (self.lastPress == SDSaintLastPress_AFK) {
        [self.viewModel sendSaintArcadeDownCmd];
    }
    if (settlement) {
        PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
        alertContentView.alertTitle = ZCLocal(@"结算");
        NSString *contentStr = [NSString stringWithFormat:@"%@：%@%@", ZCLocal(@"结算结果"), settlement, ZCLocal(@"积分")];
        NSString *rangeStr = [NSString stringWithFormat:@"%@%@", settlement, ZCLocal(@"积分")];
        [self configureContentLabel:alertContentView.theMessageLabel rangeContent:rangeStr rangeColor:[UIColor colorForHex:@"#CF2F2A"] content:contentStr];
        SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
        [alertInGameViewController insertAlertContentView:alertContentView];
        [alertInGameViewController showAlertInViewController:self];
        [self.theSaintPlayControllView endTouchAction];
        @weakify_self;
        [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            if (self.lastPress == SDSaintLastPress_Close) {
                [self dismissGame];
            }
        }];
    } else {
        PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
        alertContentView.alertTitle = ZCLocal(@"结算");
        NSString *contentStr = [NSString stringWithFormat:@"%@：0", ZCLocal(@"结算结果"), ZCLocal(@"积分")];
        NSString *rangeStr = [NSString stringWithFormat:@"0%@", ZCLocal(@"积分")];
        [self configureContentLabel:alertContentView.theMessageLabel rangeContent:rangeStr rangeColor:[UIColor colorForHex:@"#CF2F2A"] content:contentStr];
        SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
        [alertInGameViewController insertAlertContentView:alertContentView];
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
- (void)showChargeAliPayData:(NSString *) data {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [self showLoading];
        [self.theChargeInGameView showChargeAliPayData:data];
    } else {
        SDRechargeWebViewController * webViewController = [[SDRechargeWebViewController alloc] initWithData:data];
        //        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self presentViewController:webViewController animated:true completion:nil];
    }
}

- (void)configureContentLabel:(UILabel *)contentL rangeContent:(NSString *)rangeContent rangeColor:(UIColor *)color content:(NSString *)content {
    NSRange range = [content rangeOfString:rangeContent];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    contentL.attributedText = attributeString;
}

#pragma mark - SDChargeInGameViewDelegate
- (void)dissmissChargeController {
    _theChargeInGameView = nil;
    [self hideLoading];
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
        theView.pullViewForDevice = SDPullViewForSaint;
        [theView displayVideoViewForFit];
        _pullVideoView = theView;
    }
    return _pullVideoView;
}
- (PPSaintPlayerWaitView * )theSaintPlayerWaitView{
    if (!_theSaintPlayerWaitView) {
        CGFloat margin = [self.pullVideoView displayMarginLeftOrRight];
        CGFloat waitContentWidth = SCREEN_WIDTH - margin * 2;
        PPSaintPlayerWaitView * theView = [[PPSaintPlayerWaitView alloc] initWithFrame:CGRectMake(0, 0, waitContentWidth, DSize(100))];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(margin);
            make.bottom.equalTo(self.view).offset(DSize(-50));
            make.size.mas_equalTo(theView.frame.size);
        }];
        _theSaintPlayerWaitView = theView;
    }
    return _theSaintPlayerWaitView;
}
- (PPSaintPlayerControlView * )theSaintPlayControllView{
    if (!_theSaintPlayControllView) {
        PPSaintPlayerControlView * theView = [[PPSaintPlayerControlView alloc] init];
        [self.view addSubview:theView];
        CGFloat margin = [self.pullVideoView displayMarginLeftOrRight];
        theView.margin = margin;
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(DSize(-172));
            make.height.mas_equalTo(theView.frame.size.height);
            make.right.equalTo(self.view.mas_right);
        }];
        theView.hidden = true;
        @weakify_self;
        [theView.longTouchActionSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            NSInteger btType = [x integerValue];
            NSLog(@"开始点击 %ld", btType);
            if (btType == 5) {
                self.lastPress = SDSaintLastPress_Fire;
                [self.viewModel sendSaintFireStartCmd];
                [self stopGameOverCountDown];
            } else if (btType < 5) {
                self.lastPress = SDSaintLastPress_Move;
                [self.viewModel sendSaintMoveStartWithDirction:btType];
            }
        }];
        [theView.longTouchEndSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            NSInteger btType = [x integerValue];
            NSLog(@"结束点击 %ld", btType);
            if (btType == 5) {
                [self.viewModel sendSaintFireEndCmd];
                self.lastPress = SDSaintLastPress_Fire;
            } else if (btType < 5) {
                [self.viewModel sendSaintMoveEndWithDirction:btType];
                self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
                [self startGameOverCountDown];
                self.lastPress = SDSaintLastPress_Move;
            }
        }];
        [theView.simpleTouchSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            NSInteger btType = [x integerValue];
            NSLog(@"简单点击 %ld", btType);
            if (btType == 5) {
                [self.viewModel sendSaintSimpleFirCmd];
                self.lastPress = SDSaintLastPress_Fire;
            }else if (btType == 6){
                [self.viewModel sendSaintRaisebt];
                self.lastPress = SDSaintLastPress_Fire_Double;
            }else if (btType == 7){
                [self onCoinInPress];
            } else if (btType < 5) {
                [self.viewModel sendSaintMoveSimpleWithDirction:btType];
                self.lastPress = SDSaintLastPress_Move;
            }
            self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
            [self startGameOverCountDown];
        }];
        [theView.arcadeCoinSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            NSInteger coinCount = [x integerValue];
            [self onCoinInPressWithCount:coinCount];
        }];
        _theSaintPlayControllView = theView;
    }
    return _theSaintPlayControllView;
}
- (PPSaintPostionPlayingView * )theSaintPostionPlayingView{
    if (!_theSaintPostionPlayingView) {
        PPSaintPostionPlayingView * theView = [[PPSaintPostionPlayingView alloc] init];
        [self.view addSubview:theView];
        CGFloat margin = [self.pullVideoView displayMarginLeftOrRight];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(theView.frame.size);
            make.top.equalTo(self.view).offset(DSize(30));
            make.leading.equalTo(self.theCloseButton.mas_trailing).offset(DSize(10));
        }];
        @weakify_self;
        [[theView theSettlementSubject] subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            if (self.lastPress != SDSaintLastPress_Settlement) {
                [self onSaintSettlementPress];
                self.gameOverTimeValue = GAME_MAX_COUNT_TIME;
                [self startGameOverCountDown];
            }
        }];
        _theSaintPostionPlayingView = theView;
    }
    return _theSaintPostionPlayingView;
}
- (UILabel * )theGameOverCountDownLabel{
    if (!_theGameOverCountDownLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(DSize(20));
        }];
        theView.font = AutoBoldPxFont(30);
        theView.textColor = [UIColor whiteColor];
        theView.hidden = true;
        _theGameOverCountDownLabel = theView;
    }
    return _theGameOverCountDownLabel;
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
                    alertContentView.alertTitle = ZCLocal(@"确定兑换");
                    NSString *contentStr = [NSString stringWithFormat:@"%@%@%@%@%@?", ZCLocal(@"确定使用"), chargetData.chargePrice, ZCLocal(@"积分兑换"), chargetData.coinCount, ZCLocal(@"金币")];
                    NSString *first = [NSString stringWithFormat:@"%@%@", chargetData.chargePrice, ZCLocal(@"积分_alert")];
                    NSString *end = [NSString stringWithFormat:@"%@%@", chargetData.coinCount, ZCLocal(@"金币")];
                    NSRange firstRange = [contentStr rangeOfString:first];
                    NSRange endRange = [contentStr rangeOfString:end];
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
                    [attributeString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"#CF2F2A"]} range:firstRange];
                    [attributeString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"#CF2F2A"]} range:endRange];
                    alertContentView.theMessageLabel.attributedText = attributeString;
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
                    if (chargetData.payType == 3) {
                        [self.viewModel chargetByApple:chargetData];
                    } else {
                        [self.viewModel chargeByAli:chargetData];
                    }
                }
            }
        }];
        _theChargeInGameView = theView;
    }
    return _theChargeInGameView;
}
- (PPCloseButton * )theCloseButton{
    if (!_theCloseButton) {
        PPCloseButton * theView = [[PPCloseButton alloc] init];
        [self.view addSubview:theView];        
        CGFloat marginLeft = 0.0;
        if(self.iPhoneXFlag) {
            marginLeft = 44 + 5;
        } else {
            marginLeft = 15;
        }
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(theView.frame.size);
            make.left.equalTo(self.view).offset(marginLeft);
            make.top.equalTo(self.view).offset(DSize(14));
        }];
        [theView addTarget:self action:@selector(onCloseGamePress:) forControlEvents:UIControlEventTouchUpInside];
        _theCloseButton = theView;
    }
    return _theCloseButton;
}

- (UIButton * )theGameChangeRoomButton{
    if (!_theGameChangeRoomButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view.mas_trailing).inset(13);
            make.centerY.equalTo(self.theCloseButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(DSize(1), DSize(100)));
        }];
        theView.hidden = YES;
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_change_room_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapGameChangeroomPress:) forControlEvents:UIControlEventTouchUpInside];
        _theGameChangeRoomButton = theView;
    }
    return _theGameChangeRoomButton;
}

- (UIButton * )theGameRuleButton{
    if (!_theGameRuleButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.theGameRechargeButton.mas_leading).inset(13);
            make.centerY.equalTo(self.theCloseButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_rule_info_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapGameRulePress:) forControlEvents:UIControlEventTouchUpInside];
        _theGameRuleButton = theView;
    }
    return _theGameRuleButton;
}

- (UIButton *)theGameRechargeButton{
    if (!_theGameRechargeButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.theGameExchangeButton.mas_leading).inset(13);;
            make.centerY.equalTo(self.theCloseButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_recharge_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapGameRechargePress:) forControlEvents:UIControlEventTouchUpInside];
        _theGameRechargeButton = theView;
    }
    return _theGameRechargeButton;
}
- (UIButton *)theGameExchangeButton{
    if (!_theGameExchangeButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.theGameChangeRoomButton.mas_leading).inset(13);;
            make.centerY.equalTo(self.theCloseButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_change_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapPointPress:) forControlEvents:UIControlEventTouchUpInside];
        _theGameExchangeButton = theView;
    }
    return _theGameExchangeButton;
}

- (UIView *)coinContentBgView{
    if (!_coinContentBgView) {
        _coinContentBgView = [[UIView alloc] init];
        [self.view addSubview:_coinContentBgView];
        [_coinContentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.theSaintPostionPlayingView.mas_trailing).offset(10);
            make.top.mas_equalTo(self.view.mas_top).offset(DSize(40));
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

- (SJChangeRoomListAlertView *)roomListView {
    if (!_roomListView) {
        _roomListView = [[SJChangeRoomListAlertView alloc] init];
    }
    return _roomListView;
}

@end
