//
//  JKNetWorkManager.h
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JKNetWorkResult;

typedef void (^resultInfoBlock)(JKNetWorkResult *result);


@interface JKNetWorkManager : NSObject

/// post 方法
+ (NSURLSessionDataTask *)postRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished;
/// get 方法
+ (NSURLSessionDataTask *)getRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished;
/// post 方法上传图片
+ (NSURLSessionDataTask *)uploadImageWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters image:(UIImage *)image finished:(resultInfoBlock)finished;
/// put 方法
+ (NSURLSessionDataTask *)putRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished;
/// delete 方法
+ (NSURLSessionDataTask *)deleteRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished;


@end

NS_ASSUME_NONNULL_END
