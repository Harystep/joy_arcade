#import <Foundation/Foundation.h>
#import "SDNetworkHeader.h"
@class PPRequestBaseModel;
@interface PPNetworkService : NSObject
+ (void)sd_requestWithModel:(__kindof PPRequestBaseModel * _Nonnull)requestModel callBack:(SDRequestCallBack _Nonnull)responseCallBack;
+ (void)saveCacheWithRequestCacheKey:(NSString * _Nonnull)taskKey responseObj:(id  _Nullable) responseObject;
+ (void)cacheWithRequestWithCacheKey:(NSString * _Nonnull)cacheKey withResponseClass:(Class _Nonnull)responseClass callBack:(SDRequestCallBack _Nonnull)callBack;
+ (void)removeCacheWithkey:(NSString * )request_key finish:(void(^)(void))finish;
@end
