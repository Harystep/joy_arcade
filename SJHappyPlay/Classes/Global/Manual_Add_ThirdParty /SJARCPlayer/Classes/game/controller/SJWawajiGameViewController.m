#import "SJWawajiGameViewController.h"
#import "SJPullVideoView.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPWawajiNavigationHeaderView.h"
#import "AppDefineHeader.h"
#import "PPHomeLiveRoomUnitDataModel.h"
#import "PPGameControlView.h"
#import "PPGameMyMoneyView.h"
#import "PPUserInfoService.h"
#import "PPGameVideoSwitchControl.h"
#import "PPGamePlayerView.h"
#import "PPChatMessageView.h"
#import "PPTcpMoveDirctionData.h"
#import "SJPlayResultViewController.h"
#import "SJPlayAlertViewController.h"
#import "PPGameGoodDetailView.h"
#import "POP.h"
#import "PPWawajiResultViewController.h"
#import "PPStartGameLoadingView.h"
#import "PPWawajiSharedViewController.h"
#import "PPGameConfig.h"
#import "AppDefineHeader.h"
#import "SJUserMoneyDataView.h"
#import "UIImageView+WebCache.h"
#import "PPImageUtil.h"
#import "PPDefineAlertContentView.h"
#import "SJAlertInGameViewController.h"
#import "SJRechargeVerAlertView.h"
#import "SDRechargeWebViewController.h"

#define GAME_MAX_COUNT_TIME 30
@interface SJWawajiGameViewController ()<SDGameViewModelDelegate, UIGestureRecognizerDelegate, SJRechargeVerAlertViewDelegate>
@property (nonatomic, weak) PPWawajiNavigationHeaderView * navigationHeaderView;
@property (nonatomic, weak) PPGameControlView * theControllView;
@property (nonatomic, weak) SJUserMoneyDataView * theMyMoneyView;
@property (nonatomic, weak) PPGameVideoSwitchControl * gameVideoSwitchButton;
@property (nonatomic, weak) PPGamePlayerView * theGamePlayerView;
@property (nonatomic, weak) PPChatMessageView * theChatMessageView;
@property (nonatomic, assign) NSInteger first_control_type;
@property (nonatomic, assign) NSInteger last_control_type;
@property (nonatomic, weak) PPGameGoodDetailView * theGoodDetailView;
@property (nonatomic, assign) CGFloat lastPanOffsetY;
@property (nonatomic, assign) BOOL canPanMove;
@property (nonatomic, weak) PPStartGameLoadingView * theStartGameLoadingView;
@property (nonatomic,strong) UIImageView *avatarIv;
@property (nonatomic,strong) UIButton *theRepairButton;
@property (nonatomic,strong) SJRechargeVerAlertView *rechargeAlertView;

@end
@implementation SJWawajiGameViewController
@synthesize pullVideoView = _pullVideoView;
@synthesize playStatus = _playStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorForHex:@"#FAE55E"];
    self.viewModel.gameMaxTime = GAME_MAX_COUNT_TIME;
    [self configView];
    self.canPlayMusic = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:@"enterForeground" object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.canPlayMusic = true;
    [self start_play_bg_music];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"页面在这里消失吧");
    self.canPlayMusic = false;
    [self stop_play_bg_music];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.navigationHeaderView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.navigationHeaderView.frame.size.width, self.navigationHeaderView.frame.size.height);
        self.theGoodDetailView.frame = CGRectMake(0, SCREEH_HEIGHT, SCREEN_WIDTH, SCREEH_HEIGHT - self.view.safeAreaInsets.top);
    } else {
        self.navigationHeaderView.frame = CGRectMake(0, 0, self.navigationHeaderView.frame.size.width, self.navigationHeaderView.frame.size.height);
        self.theGoodDetailView.frame = CGRectMake(0, SCREEH_HEIGHT, SCREEN_WIDTH, SCREEH_HEIGHT -  20);
    }
}
#pragma mark - config
- (void)configView {
    @weakify_self;
    [[self navigationHeaderView].backSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        [self dismissGame];
    }];
    [[self theControllView].gameDoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[NSNumber class]]) {
            NSInteger actionType = [x integerValue];
            DLog(@"[game done subject] ---> %ld", actionType);
            if (actionType == recharge) {
//                [[PPGameConfig sharedInstance] goChargeForDiamondInController:self];
                [self showRechargeCoinView];
            } else if (actionType == playStartGame) {
                if (self.viewModel) {
                    if (self.theControllView.btStatus == cancelAppointmentAction) {
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
    [[self theControllView].longTouchActionSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[UIControl class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIControl * control = x;
                [self moveStartWithDirction:control.tag];
                [self play_start_effect];
            });
        }
    }];
    [[self theControllView].longTouchEndSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[UIControl class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIControl * control = x;
                [self moveEndWithDirction:control.tag];
            });
        }
    }];
    [[self theControllView].catchActionSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[UIButton class]]) {
            [self.viewModel sendCatchGrapCmd];
            [self playEffect:@"sound_grab.mp3"];
        }
    }];
    [self pullVideoView];
    [self theMyMoneyView];
    [self theGamePlayerView];
    [[self theChatMessageView].inputChatSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        [self showInputChat];
    }];
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureRecognizer:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    [self avatarIv];
    [self theMyMoneyView];
    [self theRepairButton];
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

#pragma mark - set
- (void)setPlayStatus:(SDGamePlayStatues)playStatus {
    _playStatus = playStatus;
    switch (self.playStatus) {
        case SDGame_define:
            DLog(@"==========================================现在在空闲的状态==========================================");
            [self.theControllView definePlayGame];
            if (self.theControllView.btStatus != cancelAppointmentAction) {
                [self.theControllView setBtStatus:startAction];
            }
            self.theChatMessageView.inputChatHidden = true;
            break;
        case SDGame_selfPlaying:
            DLog(@"==========================================自己在玩游戏==========================================");
            self.theChatMessageView.inputChatHidden = false;
            break;
        case SDGame_otherPlaying:
            DLog(@"==========================================别的人在游戏中==========================================");
            [self.theControllView defineOtherPlayGame];
            if (self.theControllView.btStatus != cancelAppointmentAction) {
                [self.theControllView setBtStatus:appointmentAction];
            }
            self.theChatMessageView.inputChatHidden = true;
            break;
        default:
            break;
    }
}
#pragma mark - action
- (void)appWillEnterForeground{
    [self.theControllView appWillEnterForeground];
}

- (void)onTapRepairPress:(id)sender {
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

- (void)onPanGestureRecognizer:(UIPanGestureRecognizer * )gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        DLog(@"[滑动 移动]  =====> 开始");
        self.canPanMove = false;
        self.lastPanOffsetY = touchPoint.y;
        if (self.lastPanOffsetY < SCREEH_HEIGHT / 2.0f) {
            if (self.theGoodDetailView.frame.origin.y < SCREEH_HEIGHT / 2.0) {
                self.canPanMove = true;
            }
        } else {
            if (self.theGoodDetailView.frame.origin.y > SCREEH_HEIGHT / 2.0) {
                self.canPanMove = true;
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        DLog(@"[滑动 移动]  =====> 修改 %f", touchPoint.y);
        if (self.canPanMove) {
            self.theGoodDetailView.frame = CGRectMake(0, touchPoint.y, self.theGoodDetailView.frame.size.width, self.theGoodDetailView.frame.size.height);
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed) {
        DLog(@"[滑动 移动]  =====> 结束");
        if (self.canPanMove) {
            if (self.lastPanOffsetY > SCREEH_HEIGHT / 2.0) {
                if (self.theGoodDetailView.frame.origin.y < (SCREEH_HEIGHT / 4.0f * 3.0)) {
                    [self showGoodDetailAniamtion];
                }
            } else {
                if (self.theGoodDetailView.frame.origin.y > SCREEH_HEIGHT / 4.0) {
                    [self hideGoodDetailAnimation];
                }
            }
        }
    }
}
- (void)showGoodDetailAniamtion {
    POPSpringAnimation * showAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    if (@available(iOS 11.0, *)) {
        showAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.view.safeAreaInsets.top, self.theGoodDetailView.frame.size.width, self.theGoodDetailView.frame.size.height)];
    } else {
        showAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 20, self.theGoodDetailView.frame.size.width, self.theGoodDetailView.frame.size.height)];
    }
    [self.theGoodDetailView pop_addAnimation:showAnimation forKey:@"show_animation"];
    [self.theGoodDetailView changeTab:0];
}
- (void)hideGoodDetailAnimation {
    POPBasicAnimation * hideAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    hideAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, SCREEH_HEIGHT, self.theGoodDetailView.frame.size.width, self.theGoodDetailView.frame.size.height)];
    [self.theGoodDetailView pop_addAnimation:hideAnimation forKey:@"hide_animtaion"];
}
- (void)onSwitchGameVideo {
    [self.pullVideoView switchGameVideo];
}
- (void)moveStartWithDirction:(SDPlayGameControlType)dirction
{
    [self moveWithDirction:dirction];
}
- (void)moveEndWithDirction:(SDPlayGameControlType)dirction
{
    [self moveWithDirction:(dirction + 4)];
}
- (void)moveWithDirction:(NSUInteger) dirction {
    if (dirction == SDPlayGameControl_TouchDown_UP || dirction == SDPlayGameControl_TouchDown_DOWN || dirction == SDPlayGameControl_TouchDown_LEFT || dirction == SDPlayGameControl_TouchDown_RIGHT) {
        SDMoveDirctionType dirction_type = [self getMoveDirctionWithPlayActionType:dirction];
        [self.viewModel moveWithDirction:dirction_type];
    }else{
        SDMoveDirctionType dirction_type = [self getStopMoveDirctionWithPlayActionType:dirction];
        if (dirction_type > 0) {
            [self.viewModel stopMoveWithDirction:dirction_type];
        }
    }
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
- (void)showSharedGameResult{
    PPWawajiSharedViewController * sharedViewController = [[PPWawajiSharedViewController alloc] init];
    sharedViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    sharedViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:sharedViewController animated:nil completion:nil];
}
#pragma mark - SDGameViewModelDelegate
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo {
    self.navigationHeaderView.title = roomInfo.name;
    [self.pullVideoView loginRoomId:roomInfo.liveRoomCode];
    [self.pullVideoView loadFirstStreamDefaultImageUrl:roomInfo.gameUrl];
    [self.pullVideoView loadLastStreamDefaultImageUrl:roomInfo.profileUrl];
    self.theControllView.gamePrice = roomInfo.price;
    self.theGoodDetailView.machineSn = roomInfo.machineId;
    self.first_control_type = roomInfo.cameraA;
    self.last_control_type = roomInfo.cameraB;
    self.theGoodDetailView.imgs = roomInfo.imgs;
}
- (void)updateUserInfo {
    NSLog(@"coin:%@ zhuanshi:%@", [PPUserInfoService get_Instance].goldCoin, [PPUserInfoService get_Instance].money);
    self.theMyMoneyView.priceValue = [PPUserInfoService get_Instance].goldCoin;
    self.theMyMoneyView.pointValue = [PPUserInfoService get_Instance].money;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:[PPUserInfoService get_Instance].avatar]];
    if(_rechargeAlertView) {
        self.rechargeAlertView.coinDataView.priceValue = [PPUserInfoService get_Instance].goldCoin;
        self.rechargeAlertView.coinDataView.pointValue = [PPUserInfoService get_Instance].points;
        self.rechargeAlertView.coinDataView.stoneValue = [PPUserInfoService get_Instance].money;
    }
}
- (void)changeWaitPlayer:(NSArray<SDPlayerInfoModel *> *)list {
    [self.theGamePlayerView setWaitPlayerList:list];
}
- (void)changeGameStatus:(NSInteger)gameStatus {
    self.playStatus = gameStatus;
}
- (void)changeGameAppointmentCount:(NSInteger)appointmentCount {
    self.theControllView.appointmentCount = appointmentCount;
}
- (void)changeGameMemberCount:(NSInteger)memberCount {
    self.theGamePlayerView.waitMemberCount = memberCount;
}
- (void)setCurrentPlayer:(SDPlayerInfoModel *)player {
    [self.theGamePlayerView setCurrentPlayer:player];
}
- (void)startGameWithCounDownTime:(NSInteger)cdTime {
    self.theControllView.countDownTime = cdTime;
    if (cdTime == GAME_MAX_COUNT_TIME) {
        [self playEffect:@"sound_ready_go.mp3"];
        [self.theStartGameLoadingView startLoadingAnimation];
        [self.theControllView startToPlayGame];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_theStartGameLoadingView removeFromSuperview];
        });
    } else {
        [self.theControllView startToPlayGame];
    }
}
- (void)insertChatMessageToShow:(PPChatMessageDataModel *)chatModel {
    [self.theChatMessageView insertChatMessage:chatModel];
}
- (void)showGameResult:(PPTcpReceviceData *)receviceData {
    if (receviceData.value == 1) {
        [self playEffect:@"sound_failure.mp3"];
    } else {
    }
    PPWawajiResultViewController * wawajiResultViewController = [[PPWawajiResultViewController alloc] init];
    wawajiResultViewController.resultData = receviceData;
    wawajiResultViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    wawajiResultViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:wawajiResultViewController animated:nil completion:nil];
    @weakify(self);
    [wawajiResultViewController.doneSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSNumber class]]) {
            SDWawajiResultAction resultAction = [x integerValue];
            if (resultAction == playAngin) {
                [self.viewModel sendStartGameCmd];
            } else if (resultAction == sharedAction) {
                [self showSharedGameResult];
            } else if (resultAction == playAppointment) {
                [self.viewModel sendAppointmentGameCmd];
            }
        }
    }];
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
- (void)showOtherPlayerGameResult:(PPTcpReceviceData *) receviceData {
    PPWawajiResultViewController * wawajiResultViewController = [[PPWawajiResultViewController alloc] init];
    wawajiResultViewController.resultData = receviceData;
    wawajiResultViewController.isOtherPlay = true;
    wawajiResultViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    wawajiResultViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:wawajiResultViewController animated:nil completion:nil];
}
- (void)changeGameStartPlayBtStatus:(GameButtonStatus)btStatus {
    [self.theControllView setBtStatus:btStatus];
}
- (void)showTrtcLoadingImg:(NSString *)firstImg last:(NSString *)lastImg {
    [self.pullVideoView loadFirstStreamDefaultImageUrl:firstImg];
    [self.pullVideoView loadLastStreamDefaultImageUrl:lastImg];
}

- (void)showErrorForRecharge {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:ZCLocal(@"提示") message:ZCLocal(@"游戏币不足，请充值") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:ZCLocal(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:ZCLocal(@"充值") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[PPGameConfig sharedInstance] goChargeForDiamondInController:self];
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return true;
}
#pragma mark - get
- (SDMoveDirctionType)getMoveDirctionWithPlayActionType:(SDPlayGameControlType)play_type{
    SDMoveDirctionType dirction_type = play_type;
    NSInteger camera_index = self.pullVideoView.currentStreamIndex;
    if (camera_index == 0) {
        camera_index = 1;
    }
    if (camera_index == 2) {
        if (self.last_control_type == 2) {
            switch (play_type) {
                case SDPlayGameControl_TouchDown_UP:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchDown_DOWN:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                case SDPlayGameControl_TouchDown_LEFT:
                    dirction_type = SDMoveDirctionUp;
                    break;
                case SDPlayGameControl_TouchDown_RIGHT:
                    dirction_type = SDMoveDirctionDown;
                    break;
                default:
                    break;
            }
        }else if (self.last_control_type == 3){
            switch (play_type) {
                case SDPlayGameControl_TouchDown_UP:
                    dirction_type = SDMoveDirctionDown;
                    break;
                case SDPlayGameControl_TouchDown_DOWN:
                    dirction_type = SDMoveDirctionUp;
                    break;
                case SDPlayGameControl_TouchDown_LEFT:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchDown_RIGHT:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                default:
                    break;
            }
        }else if (self.last_control_type == 4){
            switch (play_type) {
                case SDPlayGameControl_TouchDown_UP:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                case SDPlayGameControl_TouchDown_DOWN:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchDown_LEFT:
                    dirction_type = SDMoveDirctionDown;
                    break;
                case SDPlayGameControl_TouchDown_RIGHT:
                    dirction_type = SDMoveDirctionUp;
                    break;
                default:
                    break;
            }
        }
    }
    return dirction_type;
}
- (SDMoveDirctionType)getStopMoveDirctionWithPlayActionType:(SDPlayGameControlType)play_type{
    SDMoveDirctionType dirction_type = 0;
    NSInteger camera_index = self.pullVideoView.currentStreamIndex;
    if (camera_index == 0) {
        camera_index = 1;
    }
    if (camera_index == 1) {
        switch (play_type) {
            case SDPlayGameControl_TouchUp_UP:
                dirction_type = SDMoveDirctionUp;
                break;
            case SDPlayGameControl_TouchUp_DOWN:
                dirction_type = SDMoveDirctionDown;
                break;
            case SDPlayGameControl_TouchUp_LEFT:
                dirction_type = SDMoveDirctionLeft;
                break;
            case SDPlayGameControl_TouchUp_RIGHT:
                dirction_type = SDMoveDirctionRight;
                break;
            default:
                break;
        }
    }else if (camera_index == 2){
        if (self.last_control_type == 2) {
            switch (play_type) {
                case SDPlayGameControl_TouchUp_UP:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchUp_DOWN:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                case SDPlayGameControl_TouchUp_LEFT:
                    dirction_type = SDMoveDirctionUp;
                    break;
                case SDPlayGameControl_TouchUp_RIGHT:
                    dirction_type = SDMoveDirctionDown;
                    break;
                default:
                    break;
            }
        }else if(self.last_control_type == 3){
            switch (play_type) {
                case SDPlayGameControl_TouchUp_UP:
                    dirction_type = SDMoveDirctionDown;
                    break;
                case SDPlayGameControl_TouchUp_DOWN:
                    dirction_type = SDMoveDirctionUp;
                    break;
                case SDPlayGameControl_TouchUp_LEFT:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchUp_RIGHT:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                default:
                    break;
            }
        }else if (self.last_control_type == 1){
            switch (play_type) {
                case SDPlayGameControl_TouchUp_UP:
                    dirction_type = SDMoveDirctionUp;
                    break;
                case SDPlayGameControl_TouchUp_DOWN:
                    dirction_type = SDMoveDirctionDown;
                    break;
                case SDPlayGameControl_TouchUp_LEFT:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                case SDPlayGameControl_TouchUp_RIGHT:
                    dirction_type = SDMoveDirctionRight;
                    break;
                default:
                    break;
            }
        }else if (self.last_control_type == 4){
            switch (play_type) {
                case SDPlayGameControl_TouchUp_UP:
                    dirction_type = SDMoveDirctionLeft;
                    break;
                case SDPlayGameControl_TouchUp_DOWN:
                    dirction_type = SDMoveDirctionRight;
                    break;
                case SDPlayGameControl_TouchUp_LEFT:
                    dirction_type = SDMoveDirctionDown;
                    break;
                case SDPlayGameControl_TouchUp_RIGHT:
                    dirction_type = SDMoveDirctionUp;
                    break;
                default:
                    break;
            }
        }
    }
    return dirction_type;
}
#pragma mark - lazy UI
- (SJPullVideoView * )pullVideoView{
    if (!_pullVideoView) {
        SJPullVideoView * theView = [[SJPullVideoView alloc] init];
        theView.machineSn = self.machineSn;
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(DSize(10));
            make.right.equalTo(self.view.mas_right).offset(-DSize(10));
            make.top.equalTo(self.navigationHeaderView.mas_bottom);
            make.bottom.equalTo(self.theControllView.mas_top).offset(-DSize(72));
        }];
        theView.pullViewForDevice = SDPullViewForWawaji;
        _pullVideoView = theView;
    }
    return _pullVideoView;
}
- (PPWawajiNavigationHeaderView * )navigationHeaderView{
    if (!_navigationHeaderView) {
        PPWawajiNavigationHeaderView * theView = [[PPWawajiNavigationHeaderView alloc] init];
        [self.view addSubview:theView];
        _navigationHeaderView = theView;
    }
    return _navigationHeaderView;
}

- (UIImageView *)avatarIv {
    if (!_avatarIv) {
        _avatarIv = [[UIImageView alloc] init];
        [self.navigationHeaderView addSubview:_avatarIv];
        [_avatarIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(DSize(56));
            make.centerY.mas_equalTo(self.navigationHeaderView.mas_centerY);
            make.leading.mas_equalTo(self.navigationHeaderView.theBackButton.mas_trailing).offset(DSize(18));
        }];
        _avatarIv.layer.cornerRadius = DSize(28);
        _avatarIv.layer.masksToBounds = YES;
        _avatarIv.backgroundColor = RGBACOLOR(0, 0, 0, 0.40);
    }
    return _avatarIv;
}

- (PPGameControlView * )theControllView{
    if (!_theControllView) {
        PPGameControlView * theView = [[PPGameControlView alloc] initWithType:game_type_wawaji];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(theView.frame.size.width);
            make.height.mas_equalTo(theView.frame.size.height);
        }];
        _theControllView = theView;
    }
    return _theControllView;
}
- (SJUserMoneyDataView * )theMyMoneyView{
    if (!_theMyMoneyView) {
        SJUserMoneyDataView * theView = [[SJUserMoneyDataView alloc] init];
        [self.navigationHeaderView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.navigationHeaderView.mas_centerY);
            make.leading.equalTo(self.avatarIv.mas_trailing).offset(6);
        }];
        _theMyMoneyView = theView;
    }
    return _theMyMoneyView;
}
- (PPGameVideoSwitchControl * )gameVideoSwitchButton{
    if (!_gameVideoSwitchButton) {
        PPGameVideoSwitchControl * theView = [[PPGameVideoSwitchControl alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pullVideoView);
            make.right.equalTo(self.pullVideoView.mas_right);
            make.size.mas_equalTo(theView.frame.size);
        }];
        [theView addTarget:self action:@selector(onSwitchGameVideo) forControlEvents:UIControlEventTouchUpInside];
        _gameVideoSwitchButton = theView;
    }
    return _gameVideoSwitchButton;
}
- (PPGamePlayerView * )theGamePlayerView{
    if (!_theGamePlayerView) {
        PPGamePlayerView * theView = [[PPGamePlayerView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pullVideoView);
            make.top.equalTo(self.pullVideoView).offset(DSize(20));
            make.size.mas_equalTo(theView.frame.size);
        }];
        _theGamePlayerView = theView;
    }
    return _theGamePlayerView;
}
- (PPChatMessageView * )theChatMessageView{
    if (!_theChatMessageView) {
        PPChatMessageView * theView = [[PPChatMessageView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(DSize(30));
            make.bottom.equalTo(self.pullVideoView.mas_bottom).offset(-DSize(20));
            make.size.mas_equalTo(theView.frame.size);
        }];
        _theChatMessageView = theView;
    }
    return _theChatMessageView;
}
- (PPGameGoodDetailView * )theGoodDetailView{
    if (!_theGoodDetailView) {
        PPGameGoodDetailView * theView = [[PPGameGoodDetailView alloc] init];
        [self.view addSubview:theView];
        @weakify(self);
        [theView.theActionSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x integerValue] == 1) {
                [self hideGoodDetailAnimation];
            }
        }];
        _theGoodDetailView = theView;
    }
    return _theGoodDetailView;
}
- (PPStartGameLoadingView * )theStartGameLoadingView{
    if (!_theStartGameLoadingView) {
        PPStartGameLoadingView * theView = [[PPStartGameLoadingView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _theStartGameLoadingView = theView;
    }
    return _theStartGameLoadingView;
}

- (UIButton * )theRepairButton{
    if (!_theRepairButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.navigationHeaderView addSubview:theView];
        [theView setImage:[PPImageUtil imageNamed:@"img_dbj_repair_a"] forState:UIControlStateNormal];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.navigationHeaderView);
            make.trailing.equalTo(self.navigationHeaderView.mas_trailing).inset(14);
        }];
        [theView addTarget:self action:@selector(onTapRepairPress:) forControlEvents:UIControlEventTouchUpInside];
        _theRepairButton = theView;
    }
    return _theRepairButton;
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
