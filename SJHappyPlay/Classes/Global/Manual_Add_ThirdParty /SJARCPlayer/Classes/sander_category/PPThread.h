#import <Foundation/Foundation.h>
@interface PPThread : NSObject
+ (PPThread *)currentSDThread:(NSInteger)tag;
- (instancetype)init:(NSInteger )tag;
- (void) interrupt;
- (BOOL) isInterrupt;
- (void)delay:(NSTimeInterval)delay_time runBlock:(void(^)(void))runBlock;
@end
