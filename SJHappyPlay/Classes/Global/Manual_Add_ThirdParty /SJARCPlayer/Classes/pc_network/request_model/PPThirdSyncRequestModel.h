//
//  PPThirdSyncRequestModel.h
//  wawajiGame
//
//  Created by sander shan on 2023/3/13.
//

#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPThirdSyncRequestModel : PPRequestBaseModel

@property (nonatomic, strong) NSString * oauthId;

@property (nonatomic, assign) NSInteger platform;

@property (nonatomic, strong) NSString * nickname;

@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) NSString * sign;

@property (nonatomic, strong) NSString * channelKey;

- (instancetype)initWithOauthId:(NSString * )oauthId platform:(NSInteger)platform nickname:(NSString *) nickname avatar:(NSString *)avatar;

@end

NS_ASSUME_NONNULL_END
