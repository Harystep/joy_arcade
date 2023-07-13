#import "PPTcpSendPushCoinData.h"
@implementation PPTcpSendPushCoinData
- (instancetype)initWithVmc_no:(NSString *)vmc_no coin:(NSInteger)coin {
  self = [super initWithVmc_no:vmc_no cmd:@"push_coin"];
  if (self) {
    self.coin = coin;
  }
  return self;
}
+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    NSMutableArray *ignoreArray = [NSMutableArray arrayWithCapacity:0];
    [ignoreArray addObject:@"type"];
    return ignoreArray;
}
@end
