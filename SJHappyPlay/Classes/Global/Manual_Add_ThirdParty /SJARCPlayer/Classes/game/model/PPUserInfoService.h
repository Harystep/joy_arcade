#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define UserToken @"user_token"
#define backgroudmusic @"back_groud_music_1"
#define showGuidView @"showGuidView"
NS_ASSUME_NONNULL_BEGIN
@interface PPUserInfoService : NSObject
@property (nonatomic, strong) NSString * zego_userid;
@property (nonatomic, strong) NSString * zego_username;
@property (nonatomic, strong) NSString * access_token;
@property (nonatomic, assign) BOOL backGroudMusic;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * points;
@property (nonatomic, strong) NSString * goldCoin;
@property (nonatomic, strong) NSString *  userMemberId;
+ (PPUserInfoService * )get_Instance;

- (Boolean)checkShowGuid;

@end
NS_ASSUME_NONNULL_END
