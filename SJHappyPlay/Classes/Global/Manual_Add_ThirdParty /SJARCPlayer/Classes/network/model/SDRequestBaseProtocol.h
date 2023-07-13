#import <Foundation/Foundation.h>
#import "PPNetworkConfig.h"
#import "SDNetworkHeader.h"
@protocol SDRequestBaseProtocol<NSObject>
- (HTTP_METHOD)httpMethod;
- (NSTimeInterval)timeout;
- (NSString *)requestUrl;
- (AFConstructingBlock)constructingBodyBlock;
- (BOOL)cacheResponse;
- (BOOL)isShowHub;
- (Class)responseClass;
- (NSDictionary *)httpHeader;
- (NSUInteger)cacheLiveSecond;
- (HTTP_REQUEST_SERIALIZATION)requestSerialization;
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames;
- (void)requestFinish:(SDRequestCallBack)requestCallBack;
- (BOOL)checkResponseSucess;
@end
