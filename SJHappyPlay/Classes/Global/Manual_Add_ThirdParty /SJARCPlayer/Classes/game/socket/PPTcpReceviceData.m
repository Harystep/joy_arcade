#import "PPTcpReceviceData.h"
@implementation PPTcpReceviceData
- (SDTcpReceviceCMD)tcp_cmd
{   
    if ([self.cmd isEqualToString:@"conn_r"]) {
        return SDTcpReceviceCMD_conn_r;
    }else if ([self.cmd isEqualToString:@"hb_r"]){
        return SDTcpReceviceCMD_hb_r;
    }else if ([self.cmd isEqualToString:@"start_r"]){
        return SDTcpReceviceCMD_start_r;
    }else if ([self.cmd isEqualToString:@"grab_r"]){
        return SDTcpReceviceCMD_grab_r;
    }else if ([self.cmd isEqualToString:@"status"]){
        return SDTcpReceviceCMD_status;
    }else if ([self.cmd isEqualToString:@"into_room"]){
        return SDTcpReceviceCMD_into_room;
    }else if ([self.cmd isEqualToString:@"leave_room"]){
        return SDTcpReceviceCMD_leave_room;
    }else if ([self.cmd isEqualToString:@"system"]){
        return SDTcpReceviceCMD_system;
    }else if ([self.cmd isEqualToString:@"other_grab"]){
        return SDTcpReceviceCMD_other_grab;
    }else if ([self.cmd isEqualToString:@"maintain"]){
        return SDTcpReceviceCMD_maintain;
    }else if ([self.cmd isEqualToString:@"text_message"]){
        return SDTcpReceviceCMD_text_message;
    }else if ([self.cmd isEqualToString:@"appointment_r"]){
        return SDTcpReceviceCMD_appointment_r;
    }else if ([self.cmd isEqualToString:@"appointment_change"]){
        return SDTcpReceviceCMD_appointment_change;
    }else if ([self.cmd isEqualToString:@"appointment_play"]){
        return SDTcpReceviceCMD_appointment_play;
    }else if ([self.cmd isEqualToString:@"pk_r"]){
        return SDTcpReceviceCMD_pk_r;
    }else if ([self.cmd isEqualToString:@"pk_result"]){
        return SDTcpReceviceCMD_pk_result;
    }else if ([self.cmd isEqualToString:@"start_pk_r"]){
        return SDTcpReceviceCMD_start_pk_r;
    }else if ([self.cmd isEqualToString:@"end_pk_r"]){
        return SDTcpReceviceCMD_end_pk_r;
    }else if ([self.cmd isEqualToString:@"end_game_pk_r"]){
        return SDTcpReceviceCMD_end_game_pk_r;
    }else if ([self.cmd isEqualToString:@"reject_pk"]){
        return SDTcpReceviceCMD_reject_pk;
    }else if ([self.cmd isEqualToString:@"pk_time_out"]){
        return SDTcpReceviceCMD_pk_time_out;
    }else if ([self.cmd isEqualToString:@"game_url"]) {
      return SDTcpReceviceCMD_game_url;
    }else if ([self.cmd isEqualToString:@"lock_room"]){
      return SDTcpReceviceCMD_Lock_room;
    }else if ([self.cmd isEqualToString:@"free_room"]){
      return SDTcpReceviceCMD_Free_room;
    }else if ([self.cmd isEqualToString:@"push_coin_r"]){
      return SDTcpReceviceCMD_push_coin_r;
    }else if ([self.cmd isEqualToString:@"push_coin_result_r"]){
      return SDTcpReceviceCMD_push_coin_result_r;
    }else if ([self.cmd isEqualToString:@"operate_r"]) {
      return SDTcpReceviceCMD_operate_r;
    }else if ([self.cmd isEqualToString:@"arcade_down_r"] || [self.cmd isEqualToString:@"sega_arcade_down_r"]){
      return SDTcpReceviceCMD_arcade_down_r;
    }else if ([self.cmd isEqualToString:@"settlement_result_r"] || [self.cmd isEqualToString:@"sa_settlement_result_r"]) {
      return SDTcpReceviceCMD_settlement_result_r;
    }else if ([self.cmd isEqualToString:@"arcade_coin_r"] || [self.cmd isEqualToString:@"sega_arcade_coin_r"]){
      return SDTcpReceviceCMD_arcade_coin_r;
    } else{
        return SDTcpReceviceCMD_Error;
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentClampValue = -1;
        self.member_count = -1;
      self.appointmentCount = -1;
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray
{
  return @{@"players":@"SDPlayerInfoModel",@"playerList":@"SDPlayerInfoModel",@"pkList":@"SDPlayerInfoModel", @"seats": @"SDSaintSeatInfoModel"};
}
- (void)setMsg:(NSString *)msg
{
  _msg =  msg;
}
@end
@implementation SDPlayerInfoModel
@end
@implementation SDSaintSeatInfoModel
@end
