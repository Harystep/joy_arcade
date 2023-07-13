#import "PPWaWaSocketService.h"
#import "GCDAsyncSocket.h"
#import "PPTcpReceviceData.h"
#import "MJExtension.h"
@interface PPWaWaSocketService()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket * gcd_socket;
@property (nonatomic, strong) NSTimer * heartTimer;
@property (nonatomic, assign) NSInteger heartCount;
@property (nonatomic, assign) BOOL isCanLeave;
@end
@implementation PPWaWaSocketService
@synthesize socket_token = _socket_token;
@synthesize socket_macthin_sn = _socket_macthin_sn;
+ (PPWaWaSocketService * )SocketConnectedHost:(NSString * )host andPort:(NSUInteger)port andSocketDelegate:(id<SDWaWaServcieSocketDelegate>) delegate
{
    PPWaWaSocketService * service = [[PPWaWaSocketService alloc] init];
    service.socketDelegate = delegate;
    [service connectedSocketHost:host andSocketPort:port];
    return service;
}
+ (PPWaWaSocketService * )SocketConnectedHost:(NSString * )host andPort:(NSUInteger)port andSocketDelegate:(id<SDWaWaServcieSocketDelegate>) delegate match:(NSString * )machine token:(NSString * )token
{
    PPWaWaSocketService * service = [[PPWaWaSocketService alloc] initWithMachine:machine token:token];
    service.socketDelegate = delegate;
    [service connectedSocketHost:host andSocketPort:port];
    return service;
}
- (instancetype)initWithMachine:(NSString * )machine token:(NSString * )token
{
    self = [super init];
    if (self) {
        _socket_macthin_sn = machine;
        _socket_token = token;
        [self sd_configService];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sd_configService];
    }
    return self;
}
- (void)sd_configService
{
    self.gcd_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("com.socket.wawa", DISPATCH_QUEUE_CONCURRENT)];
    self.heartCount = 0;
}
- (void)retainConnectLoaclSocket{
    [self connectedSocketHost:_socket_host andSocketPort:_socket_port];
    if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(retainConnectLoaclSocket)]) {
        [self.socketDelegate retainConnectedTcpService];
    }
}
- (void)connectedSocketHost:(NSString * )host andSocketPort:(NSUInteger)port
{
    _socket_host = host;
    _socket_port = port;
    NSError * error ;
    [self.gcd_socket connectToHost:host onPort:port error:&error];
    if (!error) {
        NSLog(@"连接成功");
        [self connectingSocketedSerivce];
        [self start_heartTimer];
    }else{
        NSLog(@"连接失败-----");
    }
}
#pragma mark - action
- (void)connectingSocketedSerivce
{
    NSData * sendData = [PPWaWaSocketSendData tcpConnWithMachineSn:self.socket_macthin_sn Token:self.socket_token];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:0];
}
- (void)reservation_game{
    NSData * sendData = [PPWaWaSocketSendData tcpReservationGameWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:0];
}
- (void)start_gameWithType:(NSInteger) type{
  NSInteger deviceType = type;
  if (type == 3) {
    deviceType = 2;
  }
  if (type == 4) {
    deviceType = 3;
  }
    NSData * sendData = [PPWaWaSocketSendData tcpStartGameWithMachineSn:self.socket_macthin_sn andType:deviceType];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:2];
}
- (void)sendMessage:(NSString * )message
{
    NSData * sendData = [PPWaWaSocketSendData tcpSendMessageWithContent:message MachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:3];
}
- (void)leaveRoom
{
    NSData * sendData = [PPWaWaSocketSendData tcpLeaveRoomWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:4];
    if (self.heartTimer) {
        [self stop_heartTimer];
    }
    [self.gcd_socket disconnect];
    self.isCanLeave = true;
}
- (void)moveDirction:(SDMoveDirctionType )dirction
{
    NSData * sendData = [PPWaWaSocketSendData tcpMoveDirection:dirction MachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:5];
}
- (void)stopMoveDirction:(SDMoveDirctionType )dirction
{
    NSData * sendData = [PPWaWaSocketSendData tcpStopMoveDirection:dirction MachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:6];
}
- (void)grap
{
    NSData * sendData = [PPWaWaSocketSendData tcp_grapWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:7];
}
- (void)sendCustomTcpData:(NSData * )tcp_data{
    [self.gcd_socket writeData:tcp_data withTimeout:-1 tag:10];
}
- (void)appointment_pk{
    NSData * sendData = [PPWaWaSocketSendData tcpReservationPKGameWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:11];
}
- (void)sendPushCoinWithCoin:(NSInteger)coin {
  NSData * sendData = [PPWaWaSocketSendData tcpPushCoin:coin MachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:100];
}
- (void)sendPushCoinGameOver{
  NSData * sendData = [PPWaWaSocketSendData tcpPushCoinGameOverWithMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:101];
}
- (void)sendPushCoinDeviceWiper{
  NSData * sendData = [PPWaWaSocketSendData tcpWiperWithMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:102];
}
- (void)sendOperateWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpOperateWithMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:103];
}
- (void)sendSaintCoinWithPostion:(NSInteger)postion andIsNewGame:(BOOL) isNewGame{
  NSData * sendData = [PPWaWaSocketSendData tcpSaintCoinWithMachineSn:self.socket_macthin_sn postion:postion isNewGame:isNewGame];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:110];
}
- (void)sendSaintCoinWithPostion:(NSInteger)postion andIsNewGame:(BOOL) isNewGame andCoinCount:(NSInteger)count {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintCoinWithMachineSn:self.socket_macthin_sn postion:postion isNewGame:isNewGame coinCount:count];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:110];
}
- (void)sendSaintRaisebtWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintRaisebtWithMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:111];
}
- (void)sendSaintMoveStartDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintMoveWithMachineSn:self.socket_macthin_sn postion:postion dirction:dirction];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:104];
}
- (void)sendSaintMoveStopDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintMoveStopWithMachineSn:self.socket_macthin_sn postion:postion dirction:dirction];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:105];
}
- (void)sendSaintMoveSimpleDirction:(SDMoveDirctionType )dirction Postion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintMoveSimpleWithMachineSn:self.socket_macthin_sn postion:postion dirction:dirction];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:106];
}
- (void)sendSaintStartFireWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintStartFireMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:107];
}
- (void)sendSaintEndFireWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintEndFireMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:108];
}
- (void)sendSaintSimpleFireWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintSimpleFireMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:109];
}
- (void)sendSaintSettlementWithPostion:(NSInteger)postion {
  NSData * sendData = [PPWaWaSocketSendData tcpSaintSettlementMachineSn:self.socket_macthin_sn postion:postion];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:112];
}
- (void)sendSaintArcadeDownWithPostion: (NSInteger)postion andIsLeaveRoom:(BOOL) isLeave{
  NSData * sendData = [PPWaWaSocketSendData tcpSaintArcadeDownMachineSn:self.socket_macthin_sn postion:postion isLeaveRoom:isLeave];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:113];
}
- (void)sendGoldLegendArcadeDown{
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendArcadeDownMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:123];
}
- (void)sendGoldLegendCoin{
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendPushCoinMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:114];
}
- (void)sendGoldLegendCoinWithCoinCount:(NSInteger)count {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendPushCoinMachineSn:self.socket_macthin_sn andCoinCount:count];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:114];
}
- (void)sendGoldLegendFireDoubleCmd{
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendFireDoubleMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:115];
}
- (void)sendGoldLegendMoveStartDirction:(SDMoveDirctionType )dirction {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendMoveDirection:dirction MachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:116];
}
- (void)sendGoldLegendMoveEndDirction:(SDMoveDirctionType )dirction {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendStopMoveDirection:dirction MachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:117];
}
- (void)sendGoldLegendSimpleMoveDirction:(SDMoveDirctionType )dirction {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendSimpleMoveDirection:dirction MachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:118];
}
- (void)sendGoldLegendFireCmd {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendFireMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:119];
}
- (void)sendGoldLegendSettlementCmd {
  NSData* sendData = [PPWaWaSocketSendData tcpGoldLegendSettlementWithMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:120];
}
- (void)sendGoldLegendFireLockCmd {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendFireLockWithMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:121];
}
- (void)sendGoldLegendFireAutoCmd {
  NSData * sendData = [PPWaWaSocketSendData tcpGoldLegendFireAutoWithMachineSn:self.socket_macthin_sn];
  [self.gcd_socket writeData:sendData withTimeout:-1 tag:122];
}
- (void)orderPkGame:(BOOL)sure
{
    if (sure) {
        NSData * sendData = [PPWaWaSocketSendData tcpacceptpkGameWithMachineSn:self.socket_macthin_sn];
        [self.gcd_socket writeData:sendData withTimeout:-1 tag:12];
    }else{
        NSData * sendData = [PPWaWaSocketSendData tcprejectpkGameWithMachineSn:self.socket_macthin_sn];
        [self.gcd_socket writeData:sendData withTimeout:-1 tag:12];
    }
}
- (void)cancelApptionment {
    NSData * sendData = [PPWaWaSocketSendData tcpcancelAppointmentWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:13];
}
- (void)cancelPk{
    NSData * sendData = [PPWaWaSocketSendData tcpCancelPKWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:12];
}
#pragma mark heartbeat action
- (void)start_heartTimer
{
    if (self.heartTimer) {
        [self stop_heartTimer];
    }
    self.heartTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(heartTimerRuning) userInfo:nil repeats:YES];
    if (self.heartTimer) {
        [[NSRunLoop mainRunLoop] addTimer:self.heartTimer forMode:NSDefaultRunLoopMode];
    }
}
- (void)stop_heartTimer
{
    [self.heartTimer invalidate];
    self.heartTimer = nil;
}
- (void)heartTimerRuning
{
    self.heartCount += 30;
    NSLog(@"执行心跳");
    NSData * sendData = [PPWaWaSocketSendData tcpHeardBeatWithMachineSn:self.socket_macthin_sn];
    [self.gcd_socket writeData:sendData withTimeout:-1 tag:1];
}
#pragma mark - deal data
- (void)dealData:(NSData * )receiveData
{
    NSString * receiveDataStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"[tcp] receive %ld -----> %@" , receiveData.length, receiveDataStr);
    if (receiveData.length < 4) {
        return;
    }
    NSData *headData = [receiveData subdataWithRange:NSMakeRange(0, 4)];
    NSString *headStr = [[NSString alloc] initWithData:headData encoding:NSUTF8StringEncoding];
    if(![headStr isEqualToString:@"doll"])
    {
        return;
    }
    NSData *lengthData = [receiveData subdataWithRange:NSMakeRange(4, 4)];
    int tmpLength;
    [lengthData getBytes: &tmpLength length: sizeof(tmpLength)];
    int receiveLength = CFSwapInt32BigToHost(tmpLength);
    if(receiveData.length >= receiveLength)
    {
        NSData *sd =[receiveData subdataWithRange:NSMakeRange(8, receiveLength-8)];
        NSString *httpResponse = [[NSString alloc] initWithData:sd encoding:NSUTF8StringEncoding];
        NSLog(@"[tcp] receive data --->%@",httpResponse);
        if(httpResponse==nil)
            return;
        PPTcpReceviceData * tmpDiamond = [PPTcpReceviceData mj_objectWithKeyValues:sd];
        [self dealReceiveData:tmpDiamond];
        NSData *lastData = [receiveData subdataWithRange:NSMakeRange(receiveLength, receiveData.length-receiveLength)];
        if (lastData.length > 0) {
            [self dealData:lastData];
        }
    }
}
- (void)dealReceiveData:(PPTcpReceviceData * )tcp_data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_conn_r) {
            NSLog(@"recevice cmd connr");
            [self tcp_recevice_conn_r_WithData:tcp_data];
        }else if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_hb_r){
            NSLog(@"recevice cmd hb_r");
            self.heartCount = 0;
        }else if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_start_r){
            [self tcp_recevice_start_r_withData:tcp_data];
        }else if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_grab_r){
            [self tcp_recevice_grab_r_withData:tcp_data];
        }else if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_operate_r) {
          NSLog(@"recevice cmd operate_r");
          [self tcp_recevice_operate_r_withData:tcp_data];
        } else if ([tcp_data tcp_cmd] == SDTcpReceviceCMD_arcade_down_r){
          [self tcp_recevice_grab_r_withData:tcp_data];
        } else{
            __weak typeof(PPWaWaSocketService * )weak_self = self;
            if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:getGameMessageWithReceviceData:)]) {
                [self.socketDelegate sockectService:weak_self getGameMessageWithReceviceData:tcp_data];
            }
        }
    });
}
- (void)tcp_recevice_conn_r_WithData:(PPTcpReceviceData * )tcp_data
{
    __weak typeof(PPWaWaSocketService * )weak_self = self;
    if (tcp_data.status != 200) {
        if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:didDisconnectWithReceviceData:)]) {
            [self.socketDelegate sockectService:weak_self didDisconnectWithReceviceData:tcp_data];
        }
    }else{
        if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:didConnectedWithReceviceData:)]) {
            [self.socketDelegate sockectService:weak_self didConnectedWithReceviceData:tcp_data];
        }
    }
}
- (void)tcp_recevice_start_r_withData:(PPTcpReceviceData * )tcp_data
{
    __weak typeof(PPWaWaSocketService * )weak_self = self;
    if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:didStartGameWithReceviceData:)]) {
        [self.socketDelegate sockectService:weak_self didStartGameWithReceviceData:tcp_data];
    }
}
- (void)tcp_recevice_grab_r_withData:(PPTcpReceviceData * )tcp_data
{
    __weak typeof(PPWaWaSocketService * )weak_self = self;
    if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:didEndGameWithReceviceData:)]) {
        [self.socketDelegate sockectService:weak_self didEndGameWithReceviceData:tcp_data];
    }
}
- (void)tcp_recevice_operate_r_withData:(PPTcpReceviceData * )tcp_data {
  __weak typeof(PPWaWaSocketService * )weak_self = self;
  if (self.socketDelegate && [self.socketDelegate respondsToSelector:@selector(sockectService:didGameOperateWithReceviceData:)]) {
      [self.socketDelegate sockectService:weak_self didGameOperateWithReceviceData:tcp_data];
  }
}
#pragma mark - getter
- (NSString * )socket_token
{
    if (!_socket_token) {
        __weak typeof(PPWaWaSocketService * )weak_self = self;
        NSString * token = [self.socketDelegate takenConntedBySockectService:weak_self];
//        NSAssert(token, @"token 不能为空！！！");
        _socket_token = token;
    }
    return _socket_token;
}
- (NSString * )socket_macthin_sn
{
    if (!_socket_macthin_sn) {
        __weak typeof(PPWaWaSocketService * )weak_self = self;
        NSString * machineSn = [self.socketDelegate machineSnConnectedBySockectService:weak_self];
        NSAssert(machineSn, @"设备的序列号 不能为空！！！");
        _socket_macthin_sn = machineSn;
    }
    return _socket_macthin_sn;
}
#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"didAcceptNewSocket");
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"didConnectToHost");
    [self start_heartTimer];
#if USE_SECURE_CONNECTION
    {
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
        {
            [sock performBlock:^{
                if ([sock enableBackgroundingOnSocket])
                else
            }];
        }
#endif
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
        [settings setObject:@"www.paypal.com"
                     forKey:(NSString *)kCFStreamSSLPeerName];
        [sock startTLS:settings];
    }
#else
    {
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
        {
            [sock performBlock:^{
                if ([sock enableBackgroundingOnSocket])
                else
            }];
        }
#endif
    }
#endif
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (data == nil) {
        return;
    }
    [self dealData:data];
    [sock readDataWithTimeout:-1 tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength");
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength");
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"read time out");;
    return 0;
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"write time out");
    return 0;
}
- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidCloseReadStream");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"socketDidDisconnect");
    if (!self.isCanLeave) {
        [self retainConnectLoaclSocket];
    }
    [self stop_heartTimer];
}
- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure");
}
- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"didReceiveTrust");
}
-(void)dealloc
{
    NSLog(@"socket service ===> dealloc");
}
@end
