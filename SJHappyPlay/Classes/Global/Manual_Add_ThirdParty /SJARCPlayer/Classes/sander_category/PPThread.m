#import "PPThread.h"
@interface PPThread()
@property(atomic, assign) BOOL isInterrupt;
@property(atomic, strong) NSCondition *condition;
@end
static  dispatch_queue_t action_queue_t;
@implementation PPThread
+ (PPThread *)currentSDThread:(NSInteger)tag
{
    return [[PPThread alloc] init:tag];
}
- (instancetype)init:(NSInteger )tag
{
    self = [super init];
    if (self) {
        self.isInterrupt = false;
        self.condition = [[NSCondition alloc] init];
        if (!action_queue_t) {
            action_queue_t = dispatch_queue_create("com.sander.touch1", DISPATCH_TARGET_QUEUE_DEFAULT);
        }
    }
    return self;
}
- (void)delay:(NSTimeInterval)delay_time runBlock:(void(^)(void))runBlock
{
    self.isInterrupt = false;
    dispatch_async(action_queue_t, ^{
        [self.condition lock];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: delay_time];
        BOOL signaled = NO;
        while (!self.isInterrupt && (signaled = [self.condition waitUntilDate:date]))
        {
        }
        if (!self.isInterrupt) {
            if (runBlock) {
                runBlock();
            }
        }
        [self.condition unlock];
    });
}
- (BOOL)isInterrupt
{
    return _isInterrupt;
}
- (void) interrupt{
    [self.condition lock];
    self.isInterrupt = YES;
    [self.condition signal];
    [self.condition unlock];
}
@end
