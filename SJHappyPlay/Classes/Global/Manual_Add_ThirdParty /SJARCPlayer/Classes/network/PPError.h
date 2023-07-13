#import <Foundation/Foundation.h>
@interface PPError : NSObject
@property (nonatomic, copy) NSString * message;
- (instancetype)initWithErrorMessage:(NSString *)error_message NS_DESIGNATED_INITIALIZER;
+ (PPError *)defineNotNetWork;
@end
