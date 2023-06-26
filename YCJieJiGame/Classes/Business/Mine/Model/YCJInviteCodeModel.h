//
//  YCJInviteCodeModel.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJInviteCodeModel : NSObject
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *max_rewards;
@property(nonatomic,copy) NSString *rewards;
@end

NS_ASSUME_NONNULL_END
