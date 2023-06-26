//
//  YCJUserInfoModel.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/1.
//

#import <Foundation/Foundation.h>

#define YCJUserInfoModiyNotification @"YCJUserInfoModiyNotification"

NS_ASSUME_NONNULL_BEGIN
@interface MemberLevelDto : NSObject
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger progress;
@property (nonatomic, copy) NSString *targetMoney;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *tips;
@end

@interface YCJToken : NSObject
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *refreshToken;
@end

@interface YCJUserInfoModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *authStatus;
@property (nonatomic, copy) NSString *aliasId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *goldCoin;
@property (nonatomic, copy) NSString *goodsNum;
@property (nonatomic, copy) NSString *hxId;
@property (nonatomic, copy) NSString *hxPwd;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *isSign;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) MemberLevelDto *memberLevelDto;

@end

NS_ASSUME_NONNULL_END
