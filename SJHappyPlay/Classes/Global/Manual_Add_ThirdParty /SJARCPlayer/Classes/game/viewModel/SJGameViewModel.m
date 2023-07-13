#import "SJGameViewModel.h"
#import "PPWaWaSocketService.h"
#import "SJPCEnterMachineRequestModel.h"
#import "PPUserInfoService.h"
#import "SJPCTRTCUserSig.h"
#import "SJPCOldGetUserInfoRequestModel.h"
#import "SJPCDollLogRoomRequestBaseModel.h"
#import "AppDefineHeader.h"
#import "SJPCEnterMatchineResponseModel.h"
#import "SJPCWeiXinLoginResponseModel.h"
#import "SJBaseGameViewController.h"
#import "SJPCChargeListRequestModel.h"
#import "SJPCChargeListResponseModel.h"
#import "PPChargeUnitModel.h"
#import "PPChargetCoinData.h"
#import "PPApplePayModule.h"
#import "SJPCChargeCoinByAppleCheckRequestModel.h"
#import "SJPCPMPointRequestModel.h"
#import "SJPmPointResponseModel.h"
#import "SJPCExchagneCointByPointRequestModel.h"
#import "PPThread.h"
#import "SDGameDefineHeader.h"
#import "SJPutMachineWarningRequestModel.h"
#import "PPNetworkConfig.h"
#import "SJPCChargeRequestModel.h"
#import "PPChargeOtherPayResponseModel.h"
#import "SJRequestAppleCreateOrderModel.h"
#import "SJResponseAppleCreateOrderModel.h"

@interface SJGameViewModel ()<SDWaWaServcieSocketDelegate>
@property (nonatomic, strong) PPWaWaSocketService * socket_service;
@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, assign) BOOL isAppointment;
@property (nonatomic, assign) NSInteger appointmentCount;
@property (nonatomic, strong) PPApplePayModule * applePayModule;
@property (nonatomic, strong) PPThread * afterThread;
@property (nonatomic, assign) NSInteger gameControlStatus;
@end
@implementation SJGameViewModel
@synthesize netWorkCommand = _netWorkCommand;
@synthesize entermatchinCommand = _entermatchinCommand;
@synthesize userSigCommand = _userSigCommand;
@synthesize userInfoCommand = _userInfoCommand;
@synthesize chargetCoinCommand = _chargetCoinCommand;
@synthesize putMachineWaringCmmand = _putMachineWaringCmmand;
- (instancetype)initWithMachineSn:(NSString * )sn roomId:(NSString *)room_id
{
    self = [super init];
    if (self) {
        _machineSn = sn;
        [self configViewModel];
    }
    return self;
}
- (void)configViewModel {
    self.currentSystemError = false;
    [self configNetworkCommand];
    self.applePayModule = [PPApplePayModule sharedInstance];
}
- (void)configNetworkCommand {
    @weakify_self;
    [[[self.entermatchinCommand executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[SJPCEnterMatchineResponseModel class]]) {
            SJPCEnterMatchineResponseModel * responseModel = x;
            self.originDataModel = responseModel.data;
            self.machineId = responseModel.data.machineId;
            self.room_id = responseModel.data.liveRoomCode;
            self.imageList = responseModel.data.imgs;
            self.win_Image_url = responseModel.data.winImg;
            self.price = responseModel.data.price;
            self.game_status = responseModel.data.status;
            self.type = responseModel.data.type;
            NSString * MY_HOST = [PPNetworkConfig sharedInstance].base_my_host;
            NSUInteger MY_PORT = [PPNetworkConfig sharedInstance].base_my_port;
            self.socket_service = [PPWaWaSocketService SocketConnectedHost:MY_HOST andPort:MY_PORT andSocketDelegate:self];
            [self enterMatchinUpdateRoomInfo:self.originDataModel];
        }
        [self.userInfoCommand execute:nil];
        [self.chargetCoinCommand execute:nil];
        [self.pmPointCommand execute:nil];
    }];
    [[self.entermatchinCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify_self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissGame)]) {
                [self.delegate dismissGame];
            }
        });
    }];
    [[[self.userInfoCommand executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[SJPCWeiXinLoginResponseModel class]]) {
            SJPCWeiXinLoginResponseModel * weixinLoginResponse = x;
            SJPCLoginWeiXinResponseModel * userInfoData = weixinLoginResponse.data;
            [PPUserInfoService get_Instance].avatar = userInfoData.avatar;
            [PPUserInfoService get_Instance].mobile = userInfoData.mobile;
            [PPUserInfoService get_Instance].nickname = userInfoData.nickname;
            [PPUserInfoService get_Instance].points = userInfoData.points;
            [PPUserInfoService get_Instance].money = userInfoData.money;
            [PPUserInfoService get_Instance].goldCoin = userInfoData.goldCoin;
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateUserInfo)]) {
                [self.delegate updateUserInfo];
            }
        }
    }];
    [[self.userInfoCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify_self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissGame)]) {
                [self.delegate dismissGame];
            }
        });
    }];
    [[[self.chargetCoinCommand executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[SJPCChargeListResponseModel class]]) {
            SJPCChargeListResponseModel * response = x;
            PCChargeTypeInfoModel * chargetInfoModel = response.data;
            NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
            NSArray * chargeOptions  = chargetInfoModel.optionList;
            for (PPChargeUnitModel * model in chargeOptions) {
                NSInteger payType = [self convertPayTypeWithData:chargetInfoModel.paySupport];
                if([model.mark isEqualToString:@"周卡"]) {
                    PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:model];
                    coinModel.type = 100002;
                    coinModel.payType = payType;
                    [list addObject:coinModel];
                } else if([model.mark isEqualToString:@"月卡"]) {
                    PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:model];
                    coinModel.type = 100003;
                    coinModel.payType = payType;
                    [list addObject:coinModel];
                } else if([model.mark isEqualToString:@"首充"]) {
                    PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:model];
                    coinModel.type = 100001;
                    coinModel.payType = payType;
                    [list addObject:coinModel];
                } else {                    
                    model.payType = payType;
                    [list addObject: [[PPChargetCoinData alloc] initWithCoinData:model]];
                }
            }
            self.chargeOptionList = [list copy];
        }
    }];
    [[[self.pmPointCommand executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify_self;
        if ([x isKindOfClass:[SJPmPointResponseModel class]]) {
            SJPmPointResponseModel * response = x;
            SDPMPointChargeInfo * pmChargeInfo = response.data;
            NSArray * chargeList = pmChargeInfo.list;
            NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
            for (SDPmPointUnitDataModel * model in chargeList) {
                [list addObject: [[PPChargetCoinData alloc] initWithPmPointData:model]];
            }
            self.pmPointList = [list copy];
        }
    }];
    [[self entermatchinCommand] execute:self.machineSn];
}

- (NSInteger)convertPayTypeWithData:(NSArray *)option {
    NSInteger type = 3;
    for (NSDictionary *dic in option) {
        if([dic[@"payMode"] integerValue] == 3) {//
            type = 3;
            break;
        } else {
            type = 2;
        }
    }
    return type;
}

- (void)checkApplePay:(NSString *)data andAppleReceipt:(NSString *) receipt{
    SJPCChargeCoinByAppleCheckRequestModel * requestModel = [[SJPCChargeCoinByAppleCheckRequestModel alloc] init];
    requestModel.receipt = receipt;    
    requestModel.orderSn = data;
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        [self hideLoading];
        if (!error) {
            [self showErrorToastMessage:@"支付成功"];
            [self.applePayModule finishTransactionForAp];
            [self.userInfoCommand execute:nil];
        } else {
            [self showErrorToastMessage:@"支付失败"];
        }
    }];
}
#pragma mark - set
- (void)setIsAppointment:(BOOL)isAppointment {
    _isAppointment = isAppointment;
    NSLog(@"修改目前 预约状态 === %d", isAppointment);
    if (self.isAppointment) {
        [self changeGameStartPlayBtStatus:cancelAppointmentAction];
    } else {
        [self changeGameAppointmentCount:self.appointmentCount];
        [self changeGameStartPlayBtStatus:appointmentAction];
    }
}
- (void)setAppointmentCount:(NSInteger)appointmentCount {
    if (appointmentCount >= 0) {
        _appointmentCount = appointmentCount;
    }
    DLog(@"当前 游戏中 预约的人数： %ld", self.appointmentCount);
}
#pragma mark - public method
- (void)chargetByApple:(PPChargetCoinData * )coinData {
    SJRequestAppleCreateOrderModel *requestModel = [[SJRequestAppleCreateOrderModel alloc] init];
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    if(coinData.type == 100002 || coinData.type == 100003) {
        requestModel.productId = [NSString stringWithFormat:@"card:%@", coinData.chargeId];
    } else {
        requestModel.productId = [NSString stringWithFormat:@"option:%@", coinData.chargeId];
    }
    [self showLoading];
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if(!error) {
            SJResponseAppleCreateOrderModel *model = (SJResponseAppleCreateOrderModel *)responseModel;
            @weakify_self;
            [self.applePayModule pay:coinData.appleProductId withOrderId:coinData.originData.chargeId orderSn:model.data.orderSn withBlock:^(NSString * _Nonnull receipt) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [weakSelf.userInfoCommand execute:nil];
                });
            } withFaileBlock:^(NSString * _Nonnull errMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [weakSelf showErrorToastMessage:errMessage];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                [self showErrorToastMessage:error.message];
            });
        }
    }];
}
- (void)chargeByAli:(PPChargetCoinData *)coinData {
    [self showLoading];
    SJPCChargeRequestModel * requestModel = [[SJPCChargeRequestModel alloc] init];
    requestModel.type = 2;
    if(coinData.type == 100002 || coinData.type == 100003) {
        requestModel.b_id = [NSString stringWithFormat:@"card:%@", coinData.chargeId];
    } else {
        requestModel.b_id = [NSString stringWithFormat:@"option:%@", coinData.chargeId];
    }
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    @weakify_self;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        @strongify_self;
        [self hideLoading];
        if (!error) {
            PPChargeOtherPayResponseModel * otherPayResponseModel = (PPChargeOtherPayResponseModel *)responseModel;
            [self.delegate showChargeAliPayData:otherPayResponseModel.data];
        } else {
            [self showErrorToastMessage:error.message];
        }
    }];
}
- (void)chargeByPoint:(PPChargetCoinData * )coinData {
    [self showLoading];
    SJPCExchagneCointByPointRequestModel * requestModel = [[SJPCExchagneCointByPointRequestModel alloc] init];
    requestModel.optionId = coinData.chargeId;
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    @weakify_self;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        @strongify_self;
        [self hideLoading];
        if (!error) {
            [self showErrorToastMessage:ZCLocal(@"兑换成功")];
            [self.userInfoCommand execute:nil];
        } else {
            [self showErrorToastMessage:ZCLocal(@"兑换失败")];
        }
    }];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError*error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if(!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range2 = {0,mutStr.length};
        //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


- (void)leaveRoom {
    if (self.type != game_type_saint) {
        if (self.type == game_type_goldLegend) {
            if (self.gameControlStatus == SDGame_selfPlaying) {
                [self sendSaintArcadeDownCmd];
            } else {
                [self.socket_service leaveRoom];
            }
        } else {
            [self.socket_service leaveRoom];
        }
    } else {
        if (self.saintPlayerIndex > 0) {
            [self sendSanitArcadeDownAndLeaveRoomCmd];
        } else {
            [self.socket_service leaveRoom];
        }
    }
}
- (void)sendStartGameCmd {
    [self.socket_service start_gameWithType:self.type];
}
- (void)sendAppointmentGameCmd {
    NSInteger goldCoin = [[PPUserInfoService get_Instance].goldCoin integerValue];
    NSInteger gamePrice = [self.price integerValue];
    NSLog(@"[tap] ---> 预约游戏 %ld < %ld", goldCoin, gamePrice);
    if (goldCoin < gamePrice) {
        [self showErrorForRecharge];
        return;
    }
    
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime > self.selfGameSafeTime) {
        [self.socket_service reservation_game];
    } else {
        [self sendStartGameCmd];
    }
}
- (void)sendCancelAppointmentGameCmd {
    [self.socket_service cancelApptionment];
}
- (void)moveWithDirction:(NSUInteger) dirction {
    [self.socket_service moveDirction:dirction];
}
- (void)stopMoveWithDirction:(NSUInteger)dirction {
    [self.socket_service stopMoveDirction:dirction];
}
- (void)sendCatchGrapCmd{
    [self.socket_service grap];
}
- (void)sendChatMessage:(NSString *)message {
    [self.socket_service sendMessage:message];
}
- (void)sendRainHangingCmd {
    [self.socket_service sendPushCoinDeviceWiper];
}
- (void)sendPushCoinCmd:(NSInteger)pushCount {
    [self.socket_service sendPushCoinWithCoin:pushCount];
}
- (void)sendOffPlanCmd {
    [self.socket_service sendPushCoinGameOver];
}
- (void)sendOperateCmdWithPostion:(NSInteger)postion {
    [self.socket_service sendOperateWithPostion:postion];
}
- (void)sendSaintCoinInWithisNewGame:(BOOL) isNewGame {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendCoin];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintCoinWithPostion:self.saintPlayerIndex andIsNewGame:isNewGame];
    }
}

- (void)sendSaintCoinInWithisNewGame:(BOOL) isNewGame andCoinCount:(NSInteger)count {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendCoinWithCoinCount:count];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintCoinWithPostion:self.saintPlayerIndex andIsNewGame:isNewGame andCoinCount:count];
    }
}

- (void)sendSaintRaisebt {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendFireDoubleCmd];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintRaisebtWithPostion:self.saintPlayerIndex];
    }
}
- (void)sendSaintMoveStartWithDirction:(NSUInteger) dirction {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendMoveStartDirction:dirction];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintMoveStartDirction:dirction Postion:self.saintPlayerIndex];
    }
}
- (void)sendSaintMoveEndWithDirction:(NSUInteger) dirction {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendMoveEndDirction:dirction];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintMoveStopDirction:dirction Postion:self.saintPlayerIndex];
    }
}
- (void)sendSaintMoveSimpleWithDirction:(NSUInteger) dirction {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendSimpleMoveDirction:dirction];
        return;
    }
    if (self.saintPlayerIndex > 0 ) {
        [self.socket_service sendSaintMoveSimpleDirction:dirction Postion:self.saintPlayerIndex];
    }
}
- (void)sendSaintFireStartCmd {
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintStartFireWithPostion:self.saintPlayerIndex];
    }
}
- (void)sendSaintFireEndCmd {
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintEndFireWithPostion:self.saintPlayerIndex];
    }
}
- (void)sendSaintSimpleFirCmd {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendFireCmd];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintSimpleFireWithPostion:self.saintPlayerIndex];
    }
}
- (void)sendSaintSettlementCmd {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendSettlementCmd];
        [self showLoading];
        if (self.afterThread) {
            [self.afterThread interrupt];
            self.afterThread = nil;
        }
        self.afterThread = [PPThread currentSDThread:0];
        @weakify_self;
        [self.afterThread delay:3 runBlock:^{
            @strongify_self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSettlementResult:nil];
            });
        }];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintSettlementWithPostion:self.saintPlayerIndex];
        [self showLoading];
        if (self.afterThread) {
            [self.afterThread interrupt];
            self.afterThread = nil;
        }
        self.afterThread = [PPThread currentSDThread:0];
        @weakify_self;
        [self.afterThread delay:5 runBlock:^{
            @strongify_self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSettlementResult:nil];
            });
        }];
    }
}
- (void)sendSaintArcadeDownCmd {
    if (self.type == game_type_goldLegend) {
        [self.socket_service sendGoldLegendArcadeDown];
        return;
    }
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintArcadeDownWithPostion:self.saintPlayerIndex andIsLeaveRoom:false];
    }
}
- (void)sendSanitArcadeDownAndLeaveRoomCmd {
    if (self.saintPlayerIndex > 0) {
        [self.socket_service sendSaintArcadeDownWithPostion:self.saintPlayerIndex andIsLeaveRoom:true];
    }
}
- (void)sendGoldLegendFireLockCmd {
    [self.socket_service sendGoldLegendFireLockCmd];
}
- (void)sendGoldLegendFireAutoCmd {
    [self.socket_service sendGoldLegendFireAutoCmd];
}
#pragma mark - delegate method
- (void)loginGamePullStearm:(NSString *)roomId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginGamePullStearm:)]) {
        [self.delegate loginGamePullStearm:roomId];
    }
}
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterMatchinUpdateRoomInfo:)]) {
            [self.delegate enterMatchinUpdateRoomInfo:roomInfo];
        }
    });
}
- (void)updateUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateUserInfo)]) {
        [self.delegate updateUserInfo];
    }
}
- (void)setCurrentPlayer: (SDPlayerInfoModel * ) player{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(setCurrentPlayer:)]) {
            [self.delegate setCurrentPlayer:player];
        }
    });
}
- (void)changeWaitPlayer:(NSArray <SDPlayerInfoModel * >* )list {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeWaitPlayer:)]) {
            [self.delegate changeWaitPlayer:list];
        }
    });
}
- (void)changeGameAppointmentCount:(NSInteger) appointmentCount {
    self.appointmentCount = appointmentCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeGameAppointmentCount:)]) {
            [self.delegate changeGameAppointmentCount:appointmentCount];
        }
    });
}
- (void)changeGameStatus: (NSInteger) gameStatus {
    self.gameControlStatus = gameStatus;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeGameStatus:)]) {
            [self.delegate changeGameStatus:gameStatus];
        }
    });
}
- (void)showErrorToastMessage:(NSString * )message {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showErrorToastMessage:)]) {
            [self.delegate showErrorToastMessage:message];
        }
    });
}
- (void)showErrorForRecharge {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showErrorForRecharge)]) {
            [self.delegate showErrorForRecharge];
        }
    });
}
- (void)startGameWithCounDownTime:(NSInteger)cdTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(startGameWithCounDownTime:)]) {
            [self.delegate startGameWithCounDownTime:cdTime];
        }
    });
}
- (void)insertChatMessageToShow:(PPChatMessageDataModel * )chatModel{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(insertChatMessageToShow:)]) {
            [self.delegate insertChatMessageToShow:chatModel];
        }
    });
}
- (void)showMaintainErrorView {
    self.currentSystemError = false;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showMaintainErrorView)]) {
            [self.delegate showMaintainErrorView];
        }
    });
}
- (void)loadingVideoDefineImageView:(NSString * )firstImageUrl andLastImageView:(NSString * )lastImageView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadingVideoDefineImageView:andLastImageView:)]) {
            [self.delegate loadingVideoDefineImageView:firstImageUrl andLastImageView:lastImageView];
        }
    });
}
- (void)showGameTurnFromTCP:(PPTcpReceviceData * )receviceData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showGameTurnFromTCP:)]) {
            [self.delegate showGameTurnFromTCP:receviceData];
        }
    });
}
- (void)showGameResult:(PPTcpReceviceData *) receviceData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showGameResult:)]) {
            [self.delegate showGameResult:receviceData];
        }
    });
}
- (void)showOtherPlayerGameResult:(PPTcpReceviceData *) receviceData {
    if (self.currentSystemError) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showOtherPlayerGameResult:)]) {
            [self.delegate showOtherPlayerGameResult:receviceData];
        }
    });
}
- (void)changeGameMemberCount:(NSInteger)memberCount {
    if (memberCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(changeGameMemberCount:)]) {
                [self.delegate changeGameMemberCount:memberCount];
            }
        });
    }
}
- (void)changeGameStartPlayBtStatus:(GameButtonStatus) btStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeGameStartPlayBtStatus:)]) {
            [self.delegate changeGameStartPlayBtStatus:btStatus];
        }
    });
}
- (void)showTrtcLoadingImg:(NSString * )firstImg last:(NSString * ) lastImg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showTrtcLoadingImg:last:)]) {
            [self.delegate showTrtcLoadingImg:firstImg last:lastImg];
        }
    });
}
- (void)recevicePushCoinResult:(PPTcpReceviceData * )receviceData {
    if (receviceData.status != 200) {
        [self showErrorToastMessage:receviceData.msg];
        return;
    }
    NSString * leftCoin = receviceData.leftCoin;
    [PPUserInfoService get_Instance].goldCoin = leftCoin;
    [self updateUserInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(restartCountDownTimerForPushCoinDevice)]) {
            [self.delegate restartCountDownTimerForPushCoinDevice];
        }
    });
}
- (void)recevicePushCoin:(NSString * )coin {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(recevicePushCoin:)]) {
            [self.delegate recevicePushCoin:coin];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(restartCountDownTimerForPushCoinDevice)]) {
            [self.delegate restartCountDownTimerForPushCoinDevice];
        }
    });
}
- (void)changeSaintPlayerSeat {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeSaintPlayerSeat)]) {
            [self.delegate changeSaintPlayerSeat];
        }
    });
}
- (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showLoading)]) {
            [self.delegate showLoading];
        }
    });
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(hideLoading)]) {
            [self.delegate hideLoading];
        }
    });
}
- (void)showSettlementResult:(PPTcpReceviceData * )receviceData {
    [self hideLoading];
    NSLog(@"receviceData back:%@", receviceData);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (receviceData) {
            NSString * points = receviceData.points;
            if (self.delegate && [self.delegate respondsToSelector:@selector(showSaintSettlementResult:)]) {
                [self.delegate showSaintSettlementResult:points];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showSaintSettlementResult:)]) {
                [self.delegate showSaintSettlementResult:nil];
            }
        }
    });
}
#pragma mark - SDWaWaServcieSocketDelegate
- (NSString * )machineSnConnectedBySockectService:(PPWaWaSocketService * )service {
    return self.machineSn;
}
- (NSString * )takenConntedBySockectService:(PPWaWaSocketService * )service {
    return [PPUserInfoService get_Instance].access_token;
}
- (void)sockectService:(PPWaWaSocketService *)service didConnectedWithReceviceData:(PPTcpReceviceData *)receviceData {
    NSString * heard_url = receviceData.headUrl;
    NSInteger member_count = receviceData.member_count;
    NSInteger isGame = receviceData.isGame;
    NSInteger remainSecond = [receviceData.remainSecond integerValue];
    NSInteger room_status =receviceData.room_status;
    [PPUserInfoService get_Instance].userMemberId = receviceData.memberId;
    [self changeWaitPlayer:receviceData.players];
    [self changeGameMemberCount:member_count];
    if (room_status == 1) {
        [self changeGameStatus:SDGame_otherPlaying];
        SDPlayerInfoModel * playInfo = [[SDPlayerInfoModel alloc] init];
        playInfo.avatar = heard_url;
        playInfo.nickname = receviceData.nickname;
        [self setCurrentPlayer:playInfo];
    } else {
        if (receviceData.appointmentCount > 0) {
            [self changeGameStatus:SDGame_otherPlaying];
        } else {
            [self changeGameStatus:SDGame_define];
        }
    }
    if (self.type == 4) {
        self.seats = receviceData.seats;
        [self changeSaintPlayerSeat];
        isGame = 0;
        for (SDSaintSeatInfoModel * seatInfo in self.seats) {
            if ([seatInfo.memberId isEqualToString: receviceData.memberId]) {
                self.saintPlayerIndex = seatInfo.position;
                remainSecond = seatInfo.remainSecond;
                isGame = seatInfo.isGame;
            }
        }
    }
    if (isGame == 1) {
        [self changeGameStatus:SDGame_selfPlaying];
        [self startGameWithCounDownTime:remainSecond];
    } else {
    }
}
- (void)sockectService:(PPWaWaSocketService *)service didStartGameWithReceviceData:(PPTcpReceviceData *)receviceData {
    if (receviceData.status != 200) {
        if (receviceData.status == 40013) {
            [self showErrorForRecharge];
            return;
        }
        [self showErrorToastMessage:receviceData.msg];
        return;
    }
    NSString * remainGold = receviceData.remainGold;
    NSString * points = receviceData.points;
    NSInteger member_count = receviceData.member_count;
    NSString * heard_url = receviceData.headUrl;
    NSString * goldCoin = receviceData.goldCoin;
    [self changeGameStatus:SDGame_selfPlaying];
    [PPUserInfoService get_Instance].goldCoin = goldCoin;
    [PPUserInfoService get_Instance].money = remainGold;
    [PPUserInfoService get_Instance].points = points;
    [self updateUserInfo];
    SDPlayerInfoModel * playInfo = [[SDPlayerInfoModel alloc] init];
    playInfo.avatar = receviceData.headUrl;
    playInfo.nickname = receviceData.nickname;
    [self setCurrentPlayer:playInfo];
    [self startGameWithCounDownTime: self.gameMaxTime];
    [self changeGameAppointmentCount:receviceData.appointmentCount];
    [self changeGameMemberCount:member_count];
}
- (void)sockectService:(PPWaWaSocketService *)service didEndGameWithReceviceData:(PPTcpReceviceData *)receviceData {
    [self changeGameStatus:SDGame_define];
    if (self.type == 1) {
        PPChatMessageDataModel * chatDataModel = [[PPChatMessageDataModel alloc] init];
        chatDataModel.chatType = customMessage;
        chatDataModel.chatName = ZCLocal(@"我");
        if (receviceData.value == 1) {
            chatDataModel.message = @"抓取成功";
        } else {
            chatDataModel.message = @"差点抓中";
        }
        [self insertChatMessageToShow:chatDataModel];
        self.selfGameSafeTime = [[NSDate date] timeIntervalSince1970] + receviceData.protection_seconds;
        [self showGameResult:receviceData];
    } else if (self.type == 4) {
        self.saintPlayerIndex = 0;
    } else {
        [self setCurrentPlayer:nil];
    }
}
- (void)sockectService:(PPWaWaSocketService *)service didGameOperateWithReceviceData:(PPTcpReceviceData *)receviceData {
    if (receviceData.status != 200) {
        [self showErrorToastMessage:receviceData.msg];
        return;
    }
    self.saintPlayerIndex = receviceData.position;
    DLog(@"[operate] -------->");
    [self startGameWithCounDownTime:0];
    [self changeGameStatus:SDGame_selfPlaying];
}
- (void)sockectService:(PPWaWaSocketService *)service getGameMessageWithReceviceData:(PPTcpReceviceData *)receviceData {
    NSInteger member_count = receviceData.member_count;
    NSInteger appointmentCount = receviceData.appointmentCount > 0 ? receviceData.appointmentCount : 0;
    if (receviceData.players) {
        [self changeWaitPlayer:receviceData.players];
    }
    [self changeGameMemberCount:member_count];
    switch ([receviceData tcp_cmd]) {
        case SDTcpReceviceCMD_status: {
            NSInteger gameStatus = receviceData.gameStatus;
            if (self.type == 4) {
                if (receviceData.seats) {
                    self.seats = receviceData.seats;
                    [self changeSaintPlayerSeat];
                }
            } else {
                if (gameStatus == 1) {
                    SDPlayerInfoModel * playInfo = [[SDPlayerInfoModel alloc] init];
                    playInfo.avatar = receviceData.headUrl;
                    playInfo.nickname = receviceData.nickname;
                    [self setCurrentPlayer:playInfo];
                    [self changeGameStatus:SDGame_otherPlaying];
                } else {
                    [self changeGameStatus:SDGame_define];
                    [self setCurrentPlayer:nil];
                }
                [self changeGameAppointmentCount:appointmentCount];
            }
            break;
        }
        case SDTcpReceviceCMD_system: {
            NSString * message = receviceData.content;
            PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
            chatModel.chatType = systemMessage;
            chatModel.message = message;
            [self insertChatMessageToShow:chatModel];
            break;
        }
        case SDTcpReceviceCMD_into_room: {
            NSString * nickname = receviceData.nickname;
            NSString * message = ZCLocal(@"进入房间");
            PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
            chatModel.chatType = intoRoom;
            chatModel.message = message;
            chatModel.chatName = nickname;
            [self insertChatMessageToShow:chatModel];
            [self changeGameAppointmentCount:appointmentCount];
            break;
        }
        case SDTcpReceviceCMD_leave_room: {
            NSString * nickname = receviceData.nickname;
            NSString * message = ZCLocal(@"离开房间");
            PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
            chatModel.chatType = intoRoom;
            chatModel.message = message;
            chatModel.chatName = nickname;
            [self insertChatMessageToShow:chatModel];
            [self changeGameAppointmentCount:appointmentCount];
            break;
        }
        case SDTcpReceviceCMD_other_grab: {
            NSString * nickname = receviceData.nickname;
            NSInteger value = receviceData.value;
            if (self.type == 1) {
                if (value == 0) {
                    PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
                    chatModel.chatType = customMessage;
                    chatModel.message = @"差点就抓中了";
                    chatModel.chatName = nickname;
                    [self insertChatMessageToShow:chatModel];
                } else {
                    PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
                    chatModel.chatType = customMessage;
                    chatModel.message = @"抓中了";
                    chatModel.chatName = nickname;
                    [self insertChatMessageToShow:chatModel];
                }
                [self showOtherPlayerGameResult:receviceData];
            }
            [self changeGameAppointmentCount:appointmentCount];
            [self setCurrentPlayer:nil];
            break;
        }
        case SDTcpReceviceCMD_maintain: {
            [self showMaintainErrorView];
            break;
        }
        case SDTcpReceviceCMD_text_message: {
            NSString * message = receviceData.content;
            NSString * sender = receviceData.sender;
            PPChatMessageDataModel * chatModel = [[PPChatMessageDataModel alloc] init];
            chatModel.chatType = customMessage;
            chatModel.message = message;
            chatModel.chatName = sender;
            [self insertChatMessageToShow:chatModel];
            break;
        }
        case SDTcpReceviceCMD_appointment_r: {
            if (receviceData.status == 0) {
                if (receviceData.type == 1) {
                    [self sendStartGameCmd];
                    self.isAppointment = false;
                }else {
                    self.isAppointment = false;
                }
            } else if (receviceData.status == 1) {
                self.isAppointment = true;
            } else if (receviceData.type == 2) {
                self.isAppointment = false;
            }
            break;
        }
        case SDTcpReceviceCMD_appointment_change: {
            [self changeGameAppointmentCount:appointmentCount];
            break;
        }
        case SDTcpReceviceCMD_appointment_play: {
            [self showGameTurnFromTCP:receviceData];
            self.isAppointment = false;
            break;
        }
        case SDTcpReceviceCMD_game_url: {
            NSString * gameUrl = receviceData.gameUrl;
            NSString * profileUrl = receviceData.profileUrl;
            [self showTrtcLoadingImg:gameUrl last:profileUrl];
            break;
        }
        case SDTcpReceviceCMD_Lock_room: {
            [self showMaintainErrorView];
            break;
        }
        case SDTcpReceviceCMD_push_coin_r: {
            [self recevicePushCoinResult: receviceData];
            break;
        }
        case SDTcpReceviceCMD_push_coin_result_r: {
            NSString * points = receviceData.points;
            [self recevicePushCoin:points];
            [self.userInfoCommand execute:nil];
            break;
        }
        case SDTcpReceviceCMD_settlement_result_r: {
            if (self.afterThread) {
                [self.afterThread interrupt];
                self.afterThread = nil;
            }
            [self showSettlementResult:receviceData];
            [[self userInfoCommand] execute:nil];
            break;
        }
        case SDTcpReceviceCMD_arcade_coin_r: {
            if (receviceData.status != 200) {
                [self showErrorToastMessage:receviceData.msg];
                return;
            }
            NSString * leftCoin = receviceData.leftCoin;
            [PPUserInfoService get_Instance].goldCoin = leftCoin;
            [self.userInfoCommand execute:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark - lazy Command
- (RACCommand *)netWorkCommand
{
    if (!_netWorkCommand) {
        _netWorkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                SJPCDollLogRoomRequestBaseModel * model = [[SJPCDollLogRoomRequestBaseModel alloc] init];
                model.accessToken = [PPUserInfoService get_Instance].access_token;
                model.machineId = input;
                [model requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (error) {
                        [subscriber sendError:nil];
                    }else{
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _netWorkCommand;
}
- (RACCommand *)entermatchinCommand
{
    if (!_entermatchinCommand) {
        _entermatchinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                SJPCEnterMachineRequestModel * requestModel = [[SJPCEnterMachineRequestModel alloc] init];
                requestModel.machineSn = input;
                requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
                [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _entermatchinCommand;
}
- (RACCommand *)putMachineWaringCmmand {
    if (!_putMachineWaringCmmand) {
        _putMachineWaringCmmand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                SJPutMachineWarningRequestModel * requestModel = [[SJPutMachineWarningRequestModel alloc] initWithmachineSn:self.machineSn];
                requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
                [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _putMachineWaringCmmand;
}
- (RACCommand * )userSigCommand{
    if (!_userSigCommand) {
        _userSigCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                SJPCTRTCUserSig * userSigRequest = [[SJPCTRTCUserSig alloc] init];
                [userSigRequest requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _userSigCommand;
}
- (RACCommand * )userInfoCommand{
    if (!_userInfoCommand) {
        _userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                SJPCOldGetUserInfoRequestModel * requestModal = [[SJPCOldGetUserInfoRequestModel alloc] init];
                requestModal.accessToken = [PPUserInfoService get_Instance].access_token;
                [requestModal requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _userInfoCommand;
}
- (RACCommand * )chargetCoinCommand {
    if (!_chargetCoinCommand) {
        _chargetCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                SJPCChargeListRequestModel * requestModal = [[SJPCChargeListRequestModel alloc] init];
                requestModal.type = @"2";
                requestModal.accessToken = [PPUserInfoService get_Instance].access_token;
                [requestModal requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _chargetCoinCommand;
}
- (RACCommand *)pmPointCommand {
    if (!_pmPointCommand) {
        _pmPointCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                SJPCPMPointRequestModel * requestModel = [[SJPCPMPointRequestModel alloc] init];
                requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
                [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:responseModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _pmPointCommand;
}
- (void)dealloc {
    DLog(@"[viewModel] -----> dealoc");
}

@end
