//
//  JKNetWorkClient.h
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKNetWorkClient : AFHTTPSessionManager


+ (instancetype)shareClient;

@property (copy, nonatomic) NSString *baseUrlString;



@end

NS_ASSUME_NONNULL_END
