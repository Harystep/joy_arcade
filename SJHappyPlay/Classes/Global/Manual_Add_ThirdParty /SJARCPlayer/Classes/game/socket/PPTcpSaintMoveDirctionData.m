#import "PPTcpSaintMoveDirctionData.h"
@implementation PPTcpSaintMoveDirctionData
- (instancetype)initWithVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion {
  self = [super initWithVmc_no:vmc_no cmd:@"arcade_move"];
  if (self) {
    self.direction = dirction;
    self.position = postion;
  }
  return self;
}
- (instancetype)initWithStopVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion {
  self = [super initWithVmc_no:vmc_no cmd:@"arcade_stop"];
  if (self) {
    self.direction = dirction;
    self.position = postion;
  }
  return self;
}
- (instancetype)initWithSimpleVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion {
  self = [super initWithVmc_no:vmc_no cmd:@"single_move"];
  if (self) {
    self.direction = dirction;
    self.position = postion;
  }
  return self;
}
@end
