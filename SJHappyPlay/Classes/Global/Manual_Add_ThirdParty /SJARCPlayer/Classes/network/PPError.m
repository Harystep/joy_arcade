#import "PPError.h"
@implementation PPError
- (instancetype)init
{
    return [self initWithErrorMessage:nil];
}
- (instancetype)initWithErrorMessage:(NSString *)error_message
{
    self = [super init];
    if (self) {
        _message = error_message;
    }
    return self;
}
+ (PPError *)defineNotNetWork
{
    return [[self alloc] initWithErrorMessage:@"网络没有了！！！"];
}
- (NSString * )description
{
    return [NSString stringWithFormat:@" error : %@",self.message];
}
@end
