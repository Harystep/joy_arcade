#import "PPUserInfoService.h"
#import <sys/utsname.h>
@implementation PPUserInfoService
static PPUserInfoService * userInfo;
+ (PPUserInfoService * )get_Instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[PPUserInfoService alloc] init];
    });
    return userInfo;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [super allocWithZone:zone];
    });
    return userInfo;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sd_configUserInfoData];
    }
    return self;
}
- (void)sd_configUserInfoData {
  NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:UserToken];
  if (token) {
    self.access_token = token;
  }
  if ([[NSUserDefaults standardUserDefaults] objectForKey:backgroudmusic]) {
    self.backGroudMusic = [[NSUserDefaults standardUserDefaults] boolForKey:backgroudmusic];
  } else {
    self.backGroudMusic = true;
  }
}
- (NSString * )zego_userid
{
    if (!_zego_userid) {
        NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"zego_userid"];
        if (!userID) {
            userID = [NSString stringWithFormat:@"wawaji_ios_%u", (unsigned)arc4random()];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"zego_userid"];
        }
        _zego_userid = userID;
        NSLog(@"zego user_id = %@",_zego_userid);
    }
    return _zego_userid;
}
- (NSString * )zego_username
{
    if (!_zego_username) {
        NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zego_username"];
        if (!userName) {
            NSString *systemVerion = nil;
            UIDevice * device = [UIDevice currentDevice];
            struct utsname systemInfo;
            uname(&systemInfo);
            NSString* code = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
            code = [code stringByReplacingOccurrencesOfString:@"," withString:@"."];
            systemVerion = [NSString stringWithFormat:@"%@_%@_%@", device.model, code, device.systemVersion];
            userName = [NSString stringWithFormat:@"%@_%u", systemVerion, (unsigned)random()];
        }
        _zego_username = userName;
        NSLog(@"zego user_name = %@",_zego_username);
    }
    return _zego_username;
}
- (void)setAccess_token:(NSString *)access_token {
  _access_token = access_token;
  [[NSUserDefaults standardUserDefaults] setValue:self.access_token forKey:UserToken];
}
- (void)setBackGroudMusic:(BOOL)backGroudMusic {
  _backGroudMusic = backGroudMusic;
  [[NSUserDefaults standardUserDefaults] setBool: self.backGroudMusic forKey:backgroudmusic];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Boolean)checkShowGuid {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:showGuidView]) {
        return false;
    }
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:showGuidView];
    return true;
}
@end
