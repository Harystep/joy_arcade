#import <Foundation/Foundation.h>
#import "PPTcpMoveDirctionData.h"
@interface PPWaWaSocketSendData : NSObject
+ (NSData * )tcpConnWithMachineSn:(NSString * )machineSn Token:(NSString * )token;
+ (NSData * )tcpHeardBeatWithMachineSn:(NSString * )machineSn;
+ (NSData * )tcpStartGameWithMachineSn:(NSString * )machineSn andType:(NSInteger) type;
+ (NSData * )tcpSendMessageWithContent:(NSString * )content MachineSn:(NSString * )machineSn;
+ (NSData * )tcpLeaveRoomWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn;
+ (NSData *)tcpStopMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn;
+ (NSData * )tcp_grapWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpReservationGameWithMachineSn:(NSString * )machineSn;
+ (NSData * )tcpReservationPKGameWithMachineSn:(NSString *)machineSn;
+(NSData * )tcpacceptpkGameWithMachineSn:(NSString *)machineSn;
+ (NSData *)tcprejectpkGameWithMachineSn:(NSString *)machineSn;
+ (NSData * )tcpcancelAppointmentWithMachineSn:(NSString *)machineSn;
+ (NSData * )tcpCancelPKWithMachineSn:(NSString *)machineSn;
+ (NSData *)tcpPushCoin:(NSInteger)coin MachineSn:(NSString * )machineSn;
+ (NSData *)tcpPushCoinGameOverWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpWiperWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpOperateWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintMoveWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction;
+ (NSData * )tcpSaintMoveStopWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction;
+ (NSData *)tcpSaintMoveSimpleWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction;
+ (NSData *)tcpSaintStartFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintEndFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintSimpleFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintCoinWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion isNewGame:(BOOL) isNewGame;
+ (NSData *)tcpSaintRaisebtWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintSettlementMachineSn:(NSString *)machinSn postion:(NSInteger) postion;
+ (NSData *)tcpSaintArcadeDownMachineSn:(NSString *)machinSn postion:(NSInteger) postion isLeaveRoom:(BOOL) isLeave;
+ (NSData *)tcpGoldLegendPushCoinMachineSn:(NSString *)machinSn;
+ (NSData *)tcpGoldLegendFireDoubleMachineSn:(NSString *)machinSn;
+ (NSData *)tcpGoldLegendMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendStopMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendSimpleMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendFireMachineSn:(NSString *)machinSn;
+(NSData *)tcpGoldLegendSettlementWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendFireLockWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendFireAutoWithMachineSn:(NSString * )machineSn;
+ (NSData *)tcpGoldLegendArcadeDownMachineSn:(NSString *)machinSn;
+ (NSData *)tcpSaintCoinWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion isNewGame:(BOOL) isNewGame coinCount:(NSInteger)count;
+ (NSData *)tcpGoldLegendPushCoinMachineSn:(NSString *)machinSn andCoinCount:(NSInteger)count;
@end
