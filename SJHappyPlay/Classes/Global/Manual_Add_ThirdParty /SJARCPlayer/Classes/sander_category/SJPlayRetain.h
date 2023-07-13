#import <UIKit/UIKit.h>
#import "PPThread.h"
@interface UIControl (SJPlayRetain)
@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;
@property (nonatomic, strong) PPThread * action_thread;
@end
