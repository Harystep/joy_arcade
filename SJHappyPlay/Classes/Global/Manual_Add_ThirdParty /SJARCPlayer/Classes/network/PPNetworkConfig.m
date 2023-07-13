#import "PPNetworkConfig.h"
#define kBundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
@interface PPNetworkConfig()
@end
@implementation PPNetworkConfig
static PPNetworkConfig * instance;
+ (PPNetworkConfig * )sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPNetworkConfig alloc] init];
    });
    return instance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAppStoreReview = false;
    }
    return self;
}

- (PPCacheOptions *)cacheOptions
{
    if (!_cacheOptions) {
        _cacheOptions = [[PPCacheOptions alloc] init];
        _cacheOptions.cache_path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", kBundleID]];
        _cacheOptions.globalCacheExpirationSecond = AJCacheDefaultExpirationSecond;
        _cacheOptions.globalCacheGCSecond = AJCacheDefaultGCSecond;
    }
    if( (_cacheOptions.cache_path == nil) || [_cacheOptions.cache_path isEqualToString:@""] )
    {
        _cacheOptions.cache_path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", kBundleID]];
    }
    if (_cacheOptions.globalCacheExpirationSecond < 60) {
        _cacheOptions.globalCacheExpirationSecond = AJCacheDefaultExpirationSecond;
    }
    if (_cacheOptions.globalCacheGCSecond < 60) {
        _cacheOptions.globalCacheGCSecond = AJCacheDefaultGCSecond;
    }
    return _cacheOptions;
}
- (Boolean)inAppStoreReview {
    if (self.export_review_date) {
        NSString * export_review_date_str = self.export_review_date;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * export_date = [dateFormatter dateFromString:export_review_date_str];
        NSInteger exportReviewTime = [export_date timeIntervalSince1970];
        NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
        if (nowTime < exportReviewTime) {
            return true;
        }
    } else {
        return self.isAppStoreReview;
    }
    return false;
}
@end
