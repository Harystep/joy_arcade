#import "PPWaWaSocketSendData.h"
#import "PPTcpConnData.h"
#import "PPTcpSendMessageData.h"
#import "PPTcpSendPushCoinData.h"
#import "PPTcpSendSaintData.h"
#import "PPTcpSaintMoveDirctionData.h"
@implementation PPWaWaSocketSendData
+ (NSData * )tcpConnWithMachineSn:(NSString * )machineSn Token:(NSString * )token
{
    PPTcpConnData * tcp_conn = [[PPTcpConnData alloc] initWithToken:token Vmc_no:machineSn];
    return [tcp_conn getSendData];
}
+ (NSData * )tcpHeardBeatWithMachineSn:(NSString * )machineSn
{
    PPBaseTcpData * tcp_data = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"hb"];
    return [tcp_data getSendData];
}
+ (NSData * )tcpStartGameWithMachineSn:(NSString * )machineSn andType:(NSInteger) type
{
    PPBaseTcpData * tcp_data = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"start"];
  if (type > 0) {
    tcp_data.type = type;
  }
    return [tcp_data getSendData];
}
+ (NSData * )tcp_grapWithMachineSn:(NSString * )machineSn
{
    PPBaseTcpData * tcp_data = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"grab"];
    return [tcp_data getSendData];
}
+ (NSData * )tcpSendMessageWithContent:(NSString * )content MachineSn:(NSString * )machineSn
{
    PPTcpSendMessageData * sendData = [[PPTcpSendMessageData alloc] initWithVmc_no:machineSn content:content];
    return [sendData getSendData];
}
+ (NSData * )tcpLeaveRoomWithMachineSn:(NSString * )machineSn
{
    PPBaseTcpData * tcp_data = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"leave"];
    return [tcp_data getSendData];
}
+ (NSData *)tcpMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn{
    PPTcpMoveDirctionData * moveData = [[PPTcpMoveDirctionData alloc] initWithVmc_no:machineSn dirction:direction];
    return [moveData getSendData];
}
+ (NSData *)tcpStopMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn{
    PPTcpMoveDirctionData * stopData = [[PPTcpMoveDirctionData alloc] initWithVmc_no:machineSn cmd:@"stop" dirction:direction];
    return [stopData getSendData];
}
+ (NSData *)tcpPushCoin:(NSInteger)coin MachineSn:(NSString * )machineSn {
  PPTcpSendPushCoinData * pushCoinData = [[PPTcpSendPushCoinData alloc] initWithVmc_no:machineSn coin:coin];
  return [pushCoinData getSendData];
}
+ (NSData *)tcpWiperWithMachineSn:(NSString * )machineSn {
  PPBaseTcpData * tcp_data = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"wiper_start"];
  return [tcp_data getSendData];
}
+ (NSData *)tcpPushCoinGameOverWithMachineSn:(NSString * )machineSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"push_coin_stop"];
  return [sendData getSendData];
}
+ (NSData *)tcpOperateWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"operate"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintCoinWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion isNewGame:(BOOL) isNewGame {
  if (isNewGame) {
    SDTcpSendSaintCoinData * sendData = [[SDTcpSendSaintCoinData alloc] initWithVmc_no:machinSn position:postion cmd:@"arcade_coin"];
    sendData.isNewGame = isNewGame ? 1 : 0;
    return [sendData getSendData];
  }
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"arcade_coin"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintCoinWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion isNewGame:(BOOL) isNewGame coinCount:(NSInteger)count {
    if (isNewGame) {
      SDTcpSendSaintCoinData * sendData = [[SDTcpSendSaintCoinData alloc] initWithVmc_no:machinSn position:postion cmd:@"arcade_coin"];
      sendData.isNewGame = isNewGame ? 1 : 0;
        sendData.multiple = count;
    
        return [sendData getSendData];
    }
    PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"arcade_coin"];
    sendData.multiple = count;
    
    return [sendData getSendData];
}
+ (NSData *)tcpSaintRaisebtWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"fire_double"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintMoveWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction {
  PPTcpSaintMoveDirctionData * sendData = [[PPTcpSaintMoveDirctionData alloc] initWithVmc_no:machinSn dirction:dirction postion:postion];
  return [sendData getSendData];
}
+ (NSData * )tcpSaintMoveStopWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction {
  PPTcpSaintMoveDirctionData * sendData = [[PPTcpSaintMoveDirctionData alloc] initWithStopVmc_no:machinSn dirction:dirction postion:postion];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintMoveSimpleWithMachineSn:(NSString *)machinSn postion:(NSInteger) postion dirction:(SDMoveDirctionType )dirction {
  PPTcpSaintMoveDirctionData * sendData = [[PPTcpSaintMoveDirctionData alloc] initWithSimpleVmc_no:machinSn dirction:dirction postion:postion];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintStartFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"fire"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintEndFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"fire_stop"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintSimpleFireMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"fire_single"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintSettlementMachineSn:(NSString *)machinSn postion:(NSInteger) postion {
  PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:postion cmd:@"settlement"];
  return [sendData getSendData];
}
+ (NSData *)tcpSaintArcadeDownMachineSn:(NSString *)machinSn postion:(NSInteger) postion isLeaveRoom:(BOOL) isLeave{
  SDTcpSendSaintLeaveData * sendData = [[SDTcpSendSaintLeaveData alloc] initWithVmc_no:machinSn position:postion cmd:@"arcade_down"];
  sendData.isLeave = isLeave ? 1 : 0;
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendArcadeDownMachineSn:(NSString *)machinSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machinSn cmd:@"sega_arcade_down"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendPushCoinMachineSn:(NSString *)machinSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machinSn cmd:@"sega_arcade_coin"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendPushCoinMachineSn:(NSString *)machinSn andCoinCount:(NSInteger)count {
    PPTcpSendSaintData * sendData = [[PPTcpSendSaintData alloc] initWithVmc_no:machinSn position:1 cmd:@"arcade_coin"];
    sendData.multiple = count;
    return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendFireDoubleMachineSn:(NSString *)machinSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machinSn cmd:@"sa_fire_double"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendFireMachineSn:(NSString *)machinSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machinSn cmd:@"sega_arcade_fire"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn {
  PPTcpMoveDirctionData * stopData = [[PPTcpMoveDirctionData alloc] initWithVmc_no:machineSn cmd:@"sega_arcade_move" dirction:direction];
  return [stopData getSendData];
}
+ (NSData *)tcpGoldLegendStopMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn{
    PPTcpMoveDirctionData * stopData = [[PPTcpMoveDirctionData alloc] initWithVmc_no:machineSn cmd:@"sega_arcade_stop" dirction:direction];
    return [stopData getSendData];
}
+ (NSData *)tcpGoldLegendSimpleMoveDirection:(SDMoveDirctionType )direction MachineSn:(NSString * )machineSn{
    PPTcpMoveDirctionData * stopData = [[PPTcpMoveDirctionData alloc] initWithVmc_no:machineSn cmd:@"sa_single_move" dirction:direction];
    return [stopData getSendData];
}
+(NSData *)tcpGoldLegendSettlementWithMachineSn:(NSString * )machineSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"sa_settlement"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendFireLockWithMachineSn:(NSString * )machineSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"sa_lock"];
  return [sendData getSendData];
}
+ (NSData *)tcpGoldLegendFireAutoWithMachineSn:(NSString * )machineSn {
  PPBaseTcpData * sendData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"sa_auto"];
  return [sendData getSendData];
}
#pragma mark - 預約遊戲
+ (NSData *)tcpReservationGameWithMachineSn:(NSString * )machineSn
{
    PPBaseTcpData * stopData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"appointment"];
    return [stopData getSendData];
}
#pragma mark - 預約PKgame
+ (NSData * )tcpReservationPKGameWithMachineSn:(NSString *)machineSn
{
    PPBaseTcpData * pkData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"appointment_pk"];
    return  [pkData getSendData];
}
+(NSData * )tcpacceptpkGameWithMachineSn:(NSString *)machineSn
{
    PPBaseTcpData * pkData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"accept_pk"];
    return  [pkData getSendData];
}
+ (NSData *)tcprejectpkGameWithMachineSn:(NSString *)machineSn
{
    PPBaseTcpData * pkData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"reject_pk"];
    return  [pkData getSendData];
}
+ (NSData * )tcpcancelAppointmentWithMachineSn:(NSString *)machineSn
{
    PPBaseTcpData * pkData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"c_appointment"];
    return  [pkData getSendData];
}
+ (NSData * )tcpCancelPKWithMachineSn:(NSString *)machineSn
{
    PPBaseTcpData * pkData = [[PPBaseTcpData alloc] initWithVmc_no:machineSn cmd:@"cancel_pk"];
    return  [pkData getSendData];
}
@end
