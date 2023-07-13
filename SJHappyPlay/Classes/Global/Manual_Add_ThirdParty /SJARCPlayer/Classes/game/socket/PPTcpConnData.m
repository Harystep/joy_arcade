#import "PPTcpConnData.h"
@implementation PPTcpConnData
- (instancetype)init
{
    return [self initWithToken:nil Vmc_no:nil];
}
- (instancetype)initWithVmc_no:(NSString *)vmc_no cmd:(NSString *)cmd_s
{
    return [self initWithToken:nil Vmc_no:vmc_no];
}
- (instancetype)initWithToken:(NSString * )token Vmc_no:(NSString *)vmc_no
{
    self = [super initWithVmc_no:vmc_no cmd:@"conn"];
    if (self) {
        self.token = token;
    }
    return self;
}
@end
