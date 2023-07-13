#import "PPTcpMoveDirctionData.h"
@implementation PPTcpMoveDirctionData
- (instancetype)initWithVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction
{
    self = [super initWithVmc_no:vmc_no cmd:@"move_direction"];
    if (self) {
        self.direction = dirction;
    }
    return self;
}
- (instancetype)initWithVmc_no:(NSString *)vmc_no cmd:(NSString *)cmd_s dirction:(SDMoveDirctionType)dirction
{
    self = [super initWithVmc_no:vmc_no cmd:cmd_s];
    if (self) {
        self.direction = dirction;
    }
    return self;
}
@end
