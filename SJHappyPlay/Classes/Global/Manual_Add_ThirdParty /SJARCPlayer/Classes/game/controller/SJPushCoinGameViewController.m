#import "SJPushCoinGameViewController.h"
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
#import "SJPCGameRuleRequestModal.h"
#import "PPImageAlertContentView.h"
#import "SJAlertInGameViewController.h"
#import "PPDefineAlertContentView.h"
#import "PPImageUtil.h"
#import "PPGameConfig.h"
#import "SJUserMoneyDataView.h"
#import "AppDefineHeader.h"
#import "UIImageView+WebCache.h"
#import "SJRechargeVerAlertView.h"
#import "SDRechargeWebViewController.h"

#define GAME_MAX_COUNT_TIME 99
@interface SJPushCoinGameViewController ()<SJRechargeVerAlertViewDelegate>
//@property (nonatomic, weak) PPGamePlayerView * theGamePlayerView;
@property (nonatomic, weak) UIButton * theCloseButton;
@property (nonatomic, weak) UIView * theFunctionRightView;
@property (nonatomic, weak) UIButton * theCustomerServiceButton;
@property (nonatomic, weak) UIButton * theWarrantyButton;
@property (nonatomic, weak) UIButton * theGameRuleButton;
@property (nonatomic, weak) UIButton * theGameRankButton;
@property (nonatomic, weak) UIButton * theRainHangingButton;
@property (nonatomic, weak) PPChatMessageView * theChatMessageView;
//@property (nonatomic, weak) PPGameMyMoneyView * theMyMoneyView;
//@property (nonatomic, weak) PPGameMyMoneyView * theMyPointView;
@property (nonatomic, weak) SJPushCoinGameControlView * theGameControlView;
@property (nonatomic, weak) PPStatisticalintegralView * theStatisticalintegralView;
@property (nonatomic, strong) CAShapeLayer * functionContentMaskLayer;
@property (nonatomic,strong) UIImageView *avatarIv;
@property (nonatomic, weak) SJUserMoneyDataView * theMyMoneyView;
@property (nonatomic,strong) SJRechargeVerAlertView *rechargeAlertView;

@end
@implementation SJPushCoinGameViewController
@synthesize pullVideoView = _pullVideoView;
@synthesize playStatus = _playStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.gameMaxTime = GAME_MAX_COUNT_TIME;
    [self configView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self.theGamePlayerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view).offset(self.view.safeAreaInsets.top);
//        } else {
//            make.top.equalTo(self.view).offset(20);
//        }
//    }];
    [[self theGameControlView] mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
//    [self.theMyMoneyView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom - DSize(130));
//        } else {
//            make.bottom.equalTo(self.view).offset(- DSize(130));
//        }
//    }];
    if (@available(iOS 11.0, *)) {
        self.theStatisticalintegralView.frame = CGRectMake(self.theStatisticalintegralView.frame.origin.x, self.view.safeAreaInsets.top + 44 + DSize(16), self.theStatisticalintegralView.frame.size.width, self.theStatisticalintegralView.frame.size.height);
    } else {
        self.theStatisticalintegralView.frame = CGRectMake(self.theStatisticalintegralView.frame.origin.x, 20 + 44 + DSize(16), self.theStatisticalintegralView.frame.size.width, self.theStatisticalintegralView.frame.size.height);
    }
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
            break;
        case SDGame_selfPlaying:
            DLog(@"==========================================自己在玩游戏==========================================");
            break;
        case SDGame_otherPlaying:
            DLog(@"==========================================别的人在游戏中==========================================");
            [self.theGameControlView defineOtherPlayGame];
            if (self.theGameControlView.btStatus != cancelAppointmentAction) {
                [self.theGameControlView setBtStatus:appointmentAction];
            }
            break;
        default:
            break;
    }
}
#pragma mark - config
- (void)configView {
    self.view.backgroundColor = [UIColor redColor];
    [self pullVideoView];
    [self theCloseButton];
    [self avatarIv];
    [self theMyMoneyView];
    [self theWarrantyButton];
    //  [self theGameRuleButton];
    //  [self theGameRankButton];
    [self theChatMessageView];
//    [self theMyMoneyView];
    [self theGameControlView];
    @weakify_self;
    [[self theGameControlView].gameDoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[NSNumber class]]) {
            NSInteger actionType = [x integerValue];
            DLog(@"[game done subject] ---> %ld", actionType);
            if (actionType == recharge) {
//                [[PPGameConfig sharedInstance] goChargeForCoinInController:self];
                [self showRechargeCoinView];
            } else if (actionType == playStartGame) {
                if (self.viewModel) {
                    if (self.theGameControlView.btStatus == cancelAppointmentAction) {
                        weakSelf.theRainHangingButton.hidden = YES;
                        [self.viewModel sendCancelAppointmentGameCmd];
                    } else {
                        weakSelf.theRainHangingButton.hidden = NO;
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
    [[self theGameControlView].pushCoinSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[UIButton class]]) {
            UIButton * bt = x;
            [self.viewModel sendPushCoinCmd:bt.tag];
            [self playPushCoinEffect];
        } else if ([x isKindOfClass:[NSNumber class]]) {
            if ([x integerValue] == 0) {
                [self.viewModel sendOffPlanCmd];
                [self defineControlGame];
            }
        }
    }];
    [self.theStatisticalintegralView.offPlaneSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        [self offPlanPress];
    }];
    self.theStatisticalintegralView.integralValue = 0;
    [self defineControlGame];
}

- (void)showRechargeCoinView {
    [self rechargeAlertView];
    self.rechargeAlertView.coinDataView.priceValue = [PPUserInfoService get_Instance].goldCoin;
    self.rechargeAlertView.coinDataView.pointValue = [PPUserInfoService get_Instance].points;
    self.rechargeAlertView.coinDataView.stoneValue = [PPUserInfoService get_Instance].money;
}
#pragma mark - SJRechargeVerAlertViewDelegate
- (void)dissmissChargeController {
    _rechargeAlertView = nil;
}
- (void)showChargeAliPayViewData:(NSString *) data {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [self showLoading];
        [self.rechargeAlertView showChargeAliPayWebView:data];
    } else {
        SDRechargeWebViewController *webViewController = [[SDRechargeWebViewController alloc] initWithData:data];
        [self presentViewController:webViewController animated:true completion:nil];
    }
}

- (void)paySuccessStatus {
    [self.viewModel.userInfoCommand execute:nil];
}

#pragma mark - action
- (void)onBackPress {
    if (self.playStatus == SDGame_selfPlaying) {
        PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
        alertContentView.alertTitle = ZCLocal(@"退出房间");
        alertContentView.alertMessage = ZCLocal(@"正在游戏中,确认退出房间");
        SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
        [alertInGameViewController insertAlertContentView:alertContentView];
        alertInGameViewController.dismissCloseButton = false;
        [alertInGameViewController showAlertInViewController:self];
        @weakify_self;
        [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
            @strongify_self;
            if([x integerValue] == 1) {
                [self.viewModel sendOffPlanCmd];
                [self dismissGame];
            }
        }];
    } else {
        [self dismissGame];
    }
}
- (void)offPlanPress {
    PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
    alertContentView.alertTitle = ZCLocal(@"下机");
    alertContentView.alertMessage = ZCLocal(@"正在游戏中,确认下机");
    SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
    [alertInGameViewController insertAlertContentView:alertContentView];
    alertInGameViewController.dismissCloseButton = false;
    [alertInGameViewController showAlertInViewController:self];
    @weakify_self;
    [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if([x integerValue] == 1) {
            self.theRainHangingButton.hidden = YES;
            [self.viewModel sendOffPlanCmd];
            [self defineControlGame];
        }
    }];
}
- (void)onCustomerServicePress {
}
- (void)onWarrantyPress {
}
- (void)onGameRulePress {
}
- (void)onGameRankPress {
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
#pragma mark - HangingPress
- (void)onRainHangingPress {
    [self.viewModel sendRainHangingCmd];
}
- (void)onTapRankPress {
    [[PPGameConfig sharedInstance] onGoToRankPageInController:self];
}
- (void)onTapGameRulePress {
    [self showRulePress];
}
- (void)onTapWarrantyPress {
    PPDefineAlertContentView * alertContentView = [[PPDefineAlertContentView alloc] init];
    alertContentView.alertTitle = ZCLocal(@"报修");
    alertContentView.alertMessage = ZCLocal(@"怀疑机器坏了，是否通知维护人员");
    SJAlertInGameViewController * alertInGameViewController = [[SJAlertInGameViewController alloc] init];
    [alertInGameViewController insertAlertContentView:alertContentView];
    [alertInGameViewController showAlertInViewController:self];
    @weakify_self;
    [alertInGameViewController.alertDoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        NSInteger actionType = [x integerValue];
        if (actionType == SDAlertTypeSure) {
            [[self.viewModel putMachineWaringCmmand] execute:nil];
        }
    }];
}
- (void)defineControlGame {
    CGRect maskFrame = CGRectMake(0, DSize(90) + DSize(27), DSize(100), DSize(90) * 1 + DSize(27) * 1 + DSize(12) * 2);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(DSize(20), DSize(20))];
    self.functionContentMaskLayer.path = path.CGPath;
    self.theStatisticalintegralView.hidden = true;
    [self.theGameControlView definePlayGame];
}
- (void)showRulePress{
    [self showLoading];
    @weakify_self;
    SJPCGameRuleRequestModal * requestModal = [[SJPCGameRuleRequestModal alloc] init];
    requestModal.machineSn = self.viewModel.machineSn;
    [requestModal requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if (!error) {
            [self hideLoading];
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
#pragma mark - SDGameViewModelDelegate
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo {
    [self.pullVideoView loginRoomId:roomInfo.liveRoomCode];
    [self.pullVideoView loadFirstStreamDefaultImageUrl:roomInfo.gameUrl];
    [self.pullVideoView loadLastStreamDefaultImageUrl:roomInfo.profileUrl];
    self.theGameControlView.gamePrice = roomInfo.price;
    self.theStatisticalintegralView.type = self.viewModel.type;
}
- (void)updateUserInfo {
    self.theMyMoneyView.priceValue = [PPUserInfoService get_Instance].goldCoin;
    self.theMyMoneyView.pointValue = [PPUserInfoService get_Instance].points;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:[PPUserInfoService get_Instance].avatar]];
    if(_rechargeAlertView) {
        self.rechargeAlertView.coinDataView.priceValue = [PPUserInfoService get_Instance].goldCoin;
        self.rechargeAlertView.coinDataView.pointValue = [PPUserInfoService get_Instance].points;
        self.rechargeAlertView.coinDataView.stoneValue = [PPUserInfoService get_Instance].money;
    }
}
- (void)changeWaitPlayer:(NSArray<SDPlayerInfoModel *> *)list {
//    [self.theGamePlayerView setWaitPlayerList:list];
}
- (void)setCurrentPlayer:(SDPlayerInfoModel *)player {
//    [self.theGamePlayerView setCurrentPlayer:player];
}
- (void)changeGameMemberCount:(NSInteger)memberCount {
//    [self.theGamePlayerView setWaitMemberCount:memberCount];
}
- (void)changeGameStartPlayBtStatus:(GameButtonStatus)btStatus {
    DLog(@"[changeGameStartPlayBtStatus] ---> %ld", btStatus);
    [self.theGameControlView setBtStatus:btStatus];
}
- (void)startGameWithCounDownTime:(NSInteger)cdTime {
    self.theGameControlView.countDownTime = cdTime;
    [self.theGameControlView startToPlayGame];
    CGRect maskFrame = CGRectMake(0, 0, DSize(100), DSize(90) * 2 + DSize(27) * 1 + DSize(12) * 2);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(SF_Float(20), SF_Float(20))];
    self.functionContentMaskLayer.path = path.CGPath;
    self.theStatisticalintegralView.hidden = false;
}
- (void)insertChatMessageToShow:(PPChatMessageDataModel *)chatModel {
    [self.theChatMessageView insertChatMessage:chatModel];
}
- (void)changeGameAppointmentCount:(NSInteger)appointmentCount {
    self.theGameControlView.appointmentCount = appointmentCount;
}
- (void)changeGameStatus:(NSInteger)gameStatus {
    self.playStatus = gameStatus;
}
- (void)restartCountDownTimerForPushCoinDevice {
    self.theGameControlView.countDownTime = GAME_MAX_COUNT_TIME;
    [self.theGameControlView startCountDownTimer];
}
- (void)recevicePushCoin:(NSString * )coin {
    self.theStatisticalintegralView.integralValue = [coin integerValue];
    [self playCoinEffect];
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
- (void)showErrorForRecharge {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:ZCLocal(@"游戏币不足，请充值") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:ZCLocal(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:ZCLocal(@"充值") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[PPGameConfig sharedInstance] goChargeForCoinInController:self];
        [self showRechargeCoinView];
    }]];
    [self presentViewController:alert animated:true completion:nil];
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
        theView.pullViewForDevice = SDPullViewForPushCoin;
        [theView displayVideoViewForFit];
        _pullVideoView = theView;
    }
    return _pullVideoView;
}
//- (PPGamePlayerView * )theGamePlayerView{
//    if (!_theGamePlayerView) {
//        PPGamePlayerView * theView = [[PPGamePlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - DSize(93), DSize(72))];
//        [self.view addSubview:theView];
//        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view);
//            make.top.equalTo(self.view).offset(20);
//            make.size.mas_equalTo(theView.frame.size);
//        }];
//        _theGamePlayerView.hidden = YES;
//        _theGamePlayerView.userInteractionEnabled = NO;
//        _theGamePlayerView = theView;
//    }
//    return _theGamePlayerView;
//}
- (UIButton * )theCloseButton {
    if (!_theCloseButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        CGFloat topMaigin = STATUS_BAR_HEIGHT;
        if(iPhone_X) {
            topMaigin = STATUS_BAR_HEIGHT-10;
        }
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(35);
            make.top.equalTo(self.view).offset(topMaigin);
            make.leading.mas_equalTo(self.view).offset(14);
        }];
        [theView setImage:[PPImageUtil getImage:@"img_dbj_exit_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onBackPress) forControlEvents:UIControlEventTouchUpInside];
        _theCloseButton = theView;
    }
    return _theCloseButton;
}
- (UIView * )theFunctionRightView{
    if (!_theFunctionRightView) {
        UIView * theView = [[UIView alloc] init];
        [self.view addSubview:theView];
        CGRect maskFrame = CGRectMake(0, 0, DSize(100), DSize(90) * 2 + DSize(27) * 1 + DSize(12) * 2);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.width.mas_equalTo(SF_Float(100));
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(maskFrame.size.height);
        }];
        self.functionContentMaskLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(DSize(20), DSize(20))];
        self.functionContentMaskLayer.path = path.CGPath;
        theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        theView.layer.mask = self.functionContentMaskLayer;
        _theFunctionRightView = theView;
    }
    return _theFunctionRightView;
}
- (UIButton * )theCustomerServiceButton{
    if (!_theCustomerServiceButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.theFunctionRightView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(90));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"ico_customer_service"] forState:UIControlStateNormal];
        _theCustomerServiceButton = theView;
    }
    return _theCustomerServiceButton;
}
- (UIButton * )theWarrantyButton {
    if (!_theWarrantyButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.width.mas_equalTo(DSize(68));
            make.centerY.equalTo(self.theCloseButton.mas_centerY);
            make.trailing.equalTo(self.view.mas_trailing).inset(14);
        }];
        [theView setImage:[PPImageUtil imageNamed:@"img_dbj_repair_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapWarrantyPress) forControlEvents:UIControlEventTouchUpInside];
        _theWarrantyButton = theView;
    }
    return _theWarrantyButton;
}
- (UIButton * )theGameRuleButton{
    if (!_theGameRuleButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.theFunctionRightView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(90));
            make.centerX.equalTo(self.theFunctionRightView);
            make.top.equalTo(self.theRainHangingButton.mas_bottom).offset(DSize(27));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_rule_info_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapGameRulePress) forControlEvents:UIControlEventTouchUpInside];
        _theGameRuleButton = theView;
    }
    return _theGameRuleButton;
}
- (UIButton * )theGameRankButton{
    if (!_theGameRankButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.theFunctionRightView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theFunctionRightView);
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(90));
            make.top.equalTo(self.theGameRuleButton.mas_bottom).offset(DSize(27));
        }];
        [theView setImage:[PPImageUtil imageNamed:@"ico_game_rank"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onTapRankPress) forControlEvents:UIControlEventTouchUpInside];
        _theGameRankButton = theView;
    }
    return _theGameRankButton;
}
- (UIButton * )theRainHangingButton{
    if (!_theRainHangingButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(80));
            make.trailing.equalTo(self.view).inset(20);
            make.centerY.mas_equalTo(self.view);
        }];
        theView.hidden = YES;
        [theView setImage:[PPImageUtil imageNamed:@"img_jj_rain_hanging_en"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onRainHangingPress) forControlEvents:UIControlEventTouchUpInside];
        _theRainHangingButton = theView;
    }
    return _theRainHangingButton;
}
- (PPChatMessageView * )theChatMessageView{
    if (!_theChatMessageView) {
        PPChatMessageView * theView = [[PPChatMessageView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(DSize(30));
            make.size.mas_equalTo(theView.frame.size);
            make.bottom.equalTo(self.view.mas_bottom).inset(26);
        }];
        _theChatMessageView = theView;
    }
    return _theChatMessageView;
}
//- (PPGameMyMoneyView * )theMyMoneyView{
//    if (!_theMyMoneyView) {
//        PPGameMyMoneyView * theView = [[PPGameMyMoneyView alloc] init];
//        [self.view addSubview:theView];
//        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view);
//            make.size.mas_equalTo(theView.frame.size);
//            make.bottom.equalTo(self.view).offset(DSize(-130));
//        }];
//        [theView chagnePushCoinModel];
//        _theMyMoneyView = theView;
//    }
//    return _theMyMoneyView;
//}
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
        theView.frame = CGRectMake(SF_Float(20), CGRectGetMaxY(self.theCloseButton.frame) + SF_Float(16), theView.frame.size.width, theView.frame.size.height);
        _theStatisticalintegralView = theView;
    }
    return _theStatisticalintegralView;
}

- (UIImageView *)avatarIv {
    if (!_avatarIv) {
        _avatarIv = [[UIImageView alloc] init];
        [self.view addSubview:_avatarIv];
        [_avatarIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(DSize(56));
            make.centerY.mas_equalTo(self.theCloseButton.mas_centerY);
            make.leading.mas_equalTo(self.theCloseButton.mas_trailing).offset(DSize(18));
        }];
        _avatarIv.layer.cornerRadius = DSize(28);
        _avatarIv.layer.masksToBounds = YES;
        _avatarIv.backgroundColor = RGBACOLOR(0, 0, 0, 0.40);
    }
    return _avatarIv;
}

- (SJUserMoneyDataView * )theMyMoneyView{
    if (!_theMyMoneyView) {
        SJUserMoneyDataView * theView = [[SJUserMoneyDataView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarIv.mas_centerY);
            make.leading.equalTo(self.avatarIv.mas_trailing).offset(6);
            make.height.mas_equalTo(DSize(52));
        }];
        _theMyMoneyView = theView;
    }
    return _theMyMoneyView;
}

- (SJRechargeVerAlertView *)rechargeAlertView {
    if (!_rechargeAlertView) {
        _rechargeAlertView = [[SJRechargeVerAlertView alloc] init];
        [self.view addSubview:_rechargeAlertView];
        _rechargeAlertView.delegate = self;
        [_rechargeAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _rechargeAlertView;
}

@end
