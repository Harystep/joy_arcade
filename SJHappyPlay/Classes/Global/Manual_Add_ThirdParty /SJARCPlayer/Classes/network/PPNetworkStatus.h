#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface PPNetworkStatus : NSObject
+ (PPNetworkStatus *)sharedInstance;
- (AFNetworkReachabilityStatus)currentStatus;
- (BOOL)canReachable;
@end
