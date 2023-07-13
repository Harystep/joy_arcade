#import <Foundation/Foundation.h>
#import "PPTcpReceviceData.h"
#import "PPWaWaSocketSendData.h"
@class PPWaWaSocketService;
@protocol SDWaWaServcieSocketDelegate <NSObject>
@required
- (NSString * )machineSnConnectedBySockectService:(PPWaWaSocketService * )service;
- (NSString * )takenConntedBySockectService:(PPWaWaSocketService * )service;
@optional
- (void)sockectService:(PPWaWaSocketService * )service didConnectedWithReceviceData:(PPTcpReceviceData * )receviceData;
- (void)sockectService:(PPWaWaSocketService * )service didDisconnectWithReceviceData:(PPTcpReceviceData * )receviceData;
- (void)sockectService:(PPWaWaSocketService *)service didStartGameWithReceviceData:(PPTcpReceviceData * )receviceData;
- (void)sockectService:(PPWaWaSocketService *)service didEndGameWithReceviceData:(PPTcpReceviceData *)receviceData;
- (void)sockectService:(PPWaWaSocketService *)service getGameMessageWithReceviceData:(PPTcpReceviceData *)receviceData;
- (void)retainConnectedTcpService;
- (void)sockectService:(PPWaWaSocketService *)service didGameOperateWithReceviceData:(PPTcpReceviceData *)receviceData;
@end
@interface PPWaWaSocketService : NSObject
@property (nonatomic, copy, readonly) NSString * socket_host;
@property (nonatomic, assign, readonly) NSUInteger socket_port;
@property (nonatomic, copy, readonly) NSString * socket_token;
@property (nonatomic, copy, readonly) NSString * socket_macthin_sn;
@property (nonatomic, weak) id <SDWaWaServcieSocketDelegate> socketDelegate;
+ (PPWaWaSocketService * )SocketConnectedHost:(NSString * )host andPort:(NSUInteger)port andSocketDelegate:(id<SDWaWaServcieSocketDelegate>) delegate;
+ (PPWaWaSocketService * )SocketConnectedHost:(NSString * )host andPort:(NSUInteger)port andSocketDelegate:(id<SDWaWaServcieSocketDelegate>) delegate match:(NSString * )machine token:(NSString * )token;
- (void)start_gameWithType:(NSInteger) type;
- (void)sendMessage:(NSString * )message;
- (void)leaveRoom;
- (void)moveDirction:(SDMoveDirctionType )dirction;
- (void)stopMoveDirction:(SDMoveDirctionType )dirction;
- (void)sendCustomTcpData:(NSData * )tcp_data;
- (void)grap;
- (void)reservation_game;
- (void)appointment_pk;
- (void)orderPkGame:(BOOL)sure;
- (void)cancelApptionment;
- (void)cancelPk;
- (void)sendPushCoinWithCoin:(NSInteger)coin;
- (void)sendPushCoinGameOver;
- (void)sendPushCoinDeviceWiper;
- (void)sendOperateWithPostion:(NSInteger)postion;
- (void)sendSaintCoinWithPostion:(NSInteger)postion andIsNewGame:(BOOL) isNewGame;
- (void)sendSaintMoveStartDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion;
- (void)sendSaintMoveStopDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion;
- (void)sendSaintMoveSimpleDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion;
- (void)sendSaintStartFireWithPostion:(NSInteger)postion;
- (void)sendSaintEndFireWithPostion:(NSInteger)postion;
- (void)sendSaintSimpleFireWithPostion:(NSInteger)postion;
- (void)sendSaintRaisebtWithPostion:(NSInteger)postion;
- (void)sendSaintSettlementWithPostion:(NSInteger)postion;
- (void)sendSaintArcadeDownWithPostion: (NSInteger)postion andIsLeaveRoom:(BOOL) isLeave;
- (void)sendGoldLegendCoin;
- (void)sendGoldLegendFireDoubleCmd;
- (void)sendGoldLegendMoveStartDirction:(SDMoveDirctionType )dirction;
- (void)sendGoldLegendMoveEndDirction:(SDMoveDirctionType )dirction;
- (void)sendGoldLegendSimpleMoveDirction:(SDMoveDirctionType )dirction;
- (void)sendGoldLegendFireCmd;
- (void)sendGoldLegendSettlementCmd;
- (void)sendGoldLegendFireLockCmd;
- (void)sendGoldLegendFireAutoCmd;
- (void)sendGoldLegendArcadeDown;

- (void)sendSaintCoinWithPostion:(NSInteger)postion andIsNewGame:(BOOL) isNewGame andCoinCount:(NSInteger)count;

- (void)sendGoldLegendCoinWithCoinCount:(NSInteger)count;
@end
