#import <Foundation/Foundation.h>
extern const NSUInteger AJCacheDefaultExpirationSecond;
extern const NSUInteger AJCacheDefaultGCSecond;
@interface PPCacheOptions : NSObject
@property (nonatomic, strong) NSString * cache_path;
@property (nonatomic, assign) BOOL openCacheGC;
@property (nonatomic, assign) NSUInteger globalCacheExpirationSecond;
@property (nonatomic, assign) NSUInteger globalCacheGCSecond;
@end
