#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
  SDTcpReceviceCMD_Error,
  SDTcpReceviceCMD_conn_r,
  SDTcpReceviceCMD_hb_r,
  SDTcpReceviceCMD_start_r,
  SDTcpReceviceCMD_grab_r,
  SDTcpReceviceCMD_status, 
  SDTcpReceviceCMD_into_room, 
  SDTcpReceviceCMD_leave_room, 
  SDTcpReceviceCMD_system, 
  SDTcpReceviceCMD_other_grab, 
  SDTcpReceviceCMD_maintain, 
  SDTcpReceviceCMD_text_message, 
  SDTcpReceviceCMD_appointment_r, 
  SDTcpReceviceCMD_appointment_change, 
  SDTcpReceviceCMD_appointment_play, 
  SDTcpReceviceCMD_pk_r,
  SDTcpReceviceCMD_pk_result,
  SDTcpReceviceCMD_start_pk_r,
  SDTcpReceviceCMD_end_pk_r,
  SDTcpReceviceCMD_end_game_pk_r,
  SDTcpReceviceCMD_reject_pk,  
  SDTcpReceviceCMD_pk_time_out, 
  SDTcpReceviceCMD_game_url,
  SDTcpReceviceCMD_Lock_room,
  SDTcpReceviceCMD_Free_room,
  SDTcpReceviceCMD_push_coin_r,
  SDTcpReceviceCMD_push_coin_result_r,
  SDTcpReceviceCMD_operate_r,
  SDTcpReceviceCMD_arcade_down_r,
  SDTcpReceviceCMD_settlement_result_r,
  SDTcpReceviceCMD_arcade_coin_r,
} SDTcpReceviceCMD;
@interface PPTcpReceviceData : NSObject
@property (nonatomic, strong) NSString * cmd;
@property (nonatomic, strong) NSString * dollLogId;
@property (nonatomic, strong) NSString * headUrl;
@property (nonatomic, assign) NSInteger isGame;
@property (nonatomic, assign) NSInteger gameStatus;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSString * points;
@property (nonatomic, strong) NSString * remainGold;
@property (nonatomic, strong) NSString * remainSecond;
@property (nonatomic, assign) NSInteger room_status;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * vmc_no;
@property (nonatomic, assign) NSInteger member_count;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString * sender;
@property (nonatomic, strong) NSArray * players;
@property (nonatomic, assign) NSInteger prizeType;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger protection_seconds;
@property (nonatomic, assign) NSInteger appointmentCount;
@property (nonatomic, assign) NSInteger waitSeconds;
@property (nonatomic, strong) NSString * gold;
@property (nonatomic, strong) NSString * gameUrl;
@property (nonatomic, strong) NSString * profileUrl;
@property (nonatomic, assign) NSInteger ballNum;
@property (nonatomic, assign) NSString * level;
@property (nonatomic, strong) NSString * ballImg;
@property (nonatomic, assign) NSInteger pkResult;
@property (nonatomic, assign) NSInteger pkWaitSeconds;
@property (nonatomic, assign) NSInteger endType;
@property (nonatomic, assign)NSInteger resultType;
@property (nonatomic, assign)int pkStatus;
@property (nonatomic, strong) NSArray * playerList;
@property (nonatomic, assign) BOOL pk;
@property (nonatomic, assign) BOOL pkMember;
@property (nonatomic, strong) NSArray * pkList;
@property (nonatomic, assign) NSInteger currentClampValue;
@property (nonatomic, strong) NSString * persistentId;
@property (nonatomic, strong) NSString * leftCoin;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * goldCoin;
@property (nonatomic, strong) NSArray * seats;
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, assign) NSInteger position;
- (SDTcpReceviceCMD)tcp_cmd;
@end
@interface SDPlayerInfoModel : NSObject
@property (nonatomic, strong) NSString * member_id;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * avatar;
@end
@interface SDSaintSeatInfoModel: NSObject
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger buyLogId;
@property (nonatomic, assign) NSInteger isGame;
@property (nonatomic, assign) NSInteger remainSecond;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSString * headUrl;
@end
