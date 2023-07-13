#import "PPTcpSendSaintData.h"
@implementation PPTcpSendSaintData
- (instancetype)initWithVmc_no:(NSString *)vmc_no position:(NSInteger )position cmd:(NSString * )cmd{
  self = [super initWithVmc_no:vmc_no cmd: cmd];
  if (self) {
    self.position = position;
      self.multiple = 1;
  }
  return self;
}
@end
@implementation SDTcpSendSaintCoinData
@end
@implementation SDTcpSendSaintLeaveData
@end
