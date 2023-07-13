#import "PPResponseBaseModel.h"
@class PCLoginAccessTokenResponseModel;
@interface SJPCLoginWeiXinResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCLoginAccessTokenResponseModel * accessToken;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * hxId;
@property (nonatomic, strong) NSString * hxPwd;
@property (nonatomic, strong) NSString * inviteCode;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * points;
@property (nonatomic, strong) NSString * registerTime;
@property (nonatomic, strong) NSString * goldCoin;
@property (nonatomic, strong) NSString * dollCounts;
@property (nonatomic, strong) NSString * erpireDate;
@property (nonatomic, strong) NSString * grabCounts;
@property (nonatomic, assign) BOOL hasMember;
@property (nonatomic, strong) NSString * fragmentCounts;
@property (nonatomic, strong) NSString * grabSuccessCounts;
@end
@interface PCLoginAccessTokenResponseModel:NSObject
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * expireTime;
@property (nonatomic, strong) NSString * refreshToken;
@end
