#import "PPNetworkStatus.h"
@interface PPNetworkStatus()
@property (nonatomic, strong)AFNetworkReachabilityManager * networkManager;
@end
@implementation PPNetworkStatus
+ (PPNetworkStatus *)sharedInstance
{
    return [[self alloc] init];
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    static PPNetworkStatus * instance;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkManager = [AFNetworkReachabilityManager manager];
        [self.networkManager startMonitoring];
    }
    return self;
}
- (AFNetworkReachabilityStatus)currentStatus
{
    return self.networkManager.networkReachabilityStatus;
}
- (BOOL)canReachable
{
    return self.networkManager.reachable;
}
@end
