#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "PPChatMessageDataModel.h"
#import "PPGameStartButton.h"
NS_ASSUME_NONNULL_BEGIN
@class PPHomeLiveRoomUnitDataModel;
@class SDPlayerInfoModel;
@class PPTcpReceviceData;
@class PPChargetCoinData;
@protocol SDGameViewModelDelegate <NSObject>
@optional
- (void)loginGamePullStearm:(NSString *)roomId;
- (void)enterMatchinUpdateRoomInfo:(PPHomeLiveRoomUnitDataModel *)roomInfo;
- (void)updateUserInfo;
- (void)setCurrentPlayer: (SDPlayerInfoModel * ) player;
- (void)changeWaitPlayer:(NSArray <SDPlayerInfoModel * >* )list;
- (void)changeGameAppointmentCount:(NSInteger) appointmentCount;
- (void)changeGameMemberCount:(NSInteger)memberCount;
- (void)changeGameStatus: (NSInteger) gameStatus;
- (void)showErrorToastMessage:(NSString * )message;
- (void)startGameWithCounDownTime:(NSInteger)cdTime;
- (void)showGameTurnFromTCP:(PPTcpReceviceData * )receviceData;
- (void)insertChatMessageToShow:(PPChatMessageDataModel * )chatModel;
- (void)showMaintainErrorView;
- (void)loadingVideoDefineImageView:(NSString * )firstImageUrl andLastImageView:(NSString * )lastImageView;
- (void)showGameResult:(PPTcpReceviceData *) receviceData;
- (void)showOtherPlayerGameResult:(PPTcpReceviceData *) receviceData;
- (void)changeGameStartPlayBtStatus:(GameButtonStatus) btStatus;
- (void)showTrtcLoadingImg:(NSString * )firstImg last:(NSString * ) lastImg;
- (void)restartCountDownTimerForPushCoinDevice;
- (void)recevicePushCoin:(NSString * )coin;
- (void)showSaintSettlementResult:(NSString *)settlement;
- (void)changeSaintPlayerSeat;
- (void)showLoading;
- (void)hideLoading;
- (void)dismissGame;
- (void)showChargeAliPayData:(NSString *) data;
- (void)showErrorForRecharge;
@end
@interface SJGameViewModel : NSObject
@property (nonatomic, assign) NSInteger gameMaxTime;
@property (nonatomic, weak) id<SDGameViewModelDelegate> delegate;
@property (nonatomic, strong) PPHomeLiveRoomUnitDataModel * originDataModel;
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, copy) NSString * machineId;
@property (nonatomic, copy) NSString * room_id;
@property (nonatomic, strong) NSArray * imageList;
@property (nonatomic, strong) NSString * win_Image_url;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger game_status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * localUrl;
@property (nonatomic, assign) BOOL currentSystemError;
@property (nonatomic, assign) NSInteger selfGameSafeTime;
@property (nonatomic, assign) NSInteger saintPlayerIndex;
@property (nonatomic, strong) NSArray * seats;
@property (nonatomic, strong) NSArray * chargeOptionList;
@property (nonatomic, strong) NSArray * pmPointList;
@property (nonatomic, strong, readonly) RACCommand * entermatchinCommand;
@property (nonatomic, strong, readonly) RACCommand * userSigCommand;
@property (nonatomic, strong, readonly) RACCommand * userInfoCommand;
@property (nonatomic, strong, readonly) RACCommand * netWorkCommand;
@property (nonatomic, strong, readonly) RACCommand * chargetCoinCommand;
@property (nonatomic, strong) RACCommand * pmPointCommand;
@property (nonatomic, strong, readonly) RACCommand * putMachineWaringCmmand;
- (instancetype)initWithMachineSn:(NSString * )sn roomId:(NSString *)room_id;
- (void)leaveRoom;
- (void)sendStartGameCmd;
- (void)sendAppointmentGameCmd;
- (void)sendCancelAppointmentGameCmd;
- (void)moveWithDirction:(NSUInteger) dirction;
- (void)stopMoveWithDirction:(NSUInteger)dirction;
- (void)sendCatchGrapCmd;
- (void)sendChatMessage:(NSString *)message;
- (void)sendRainHangingCmd;
- (void)sendPushCoinCmd:(NSInteger)pushCount;
- (void)sendOffPlanCmd;
- (void)sendOperateCmdWithPostion:(NSInteger)postion;
- (void)sendSaintMoveStartWithDirction:(NSUInteger) dirction;
- (void)sendSaintMoveEndWithDirction:(NSUInteger) dirction;
- (void)sendSaintMoveSimpleWithDirction:(NSUInteger) dirction;
- (void)sendSaintFireStartCmd;
- (void)sendSaintFireEndCmd;
- (void)sendSaintSimpleFirCmd;
- (void)sendSaintRaisebt;
- (void)sendSaintCoinInWithisNewGame:(BOOL) isNewGame;
- (void)sendSaintCoinInWithisNewGame:(BOOL) isNewGame andCoinCount:(NSInteger)count;
- (void)sendSaintSettlementCmd;
- (void)sendSaintArcadeDownCmd;
- (void)chargetByApple:(PPChargetCoinData * )coinData;
- (void)chargeByAli:(PPChargetCoinData *)coinData;
- (void)chargeByPoint:(PPChargetCoinData * )coinData;
- (void)sendSanitArcadeDownAndLeaveRoomCmd;
- (void)sendGoldLegendFireLockCmd;
- (void)sendGoldLegendFireAutoCmd;
@end
NS_ASSUME_NONNULL_END
