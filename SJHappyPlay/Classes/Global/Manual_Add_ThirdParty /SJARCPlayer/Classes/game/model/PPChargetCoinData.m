#import "PPChargetCoinData.h"
#import "PPNetworkConfig.h"
@implementation PPChargetCoinData
- (instancetype)initWithCoinData:(PPChargeUnitModel * )unit
{
  self = [super init];
  if (self) {
    _originData = unit;
    [self configData];
  }
  return self;
}
- (instancetype)initWithPmPointData:(SDPmPointUnitDataModel * )data
{
  self = [super init];
  if (self) {
    _originPointData = data;
    [self configPointData];
  }
  return self;
}
- (void)configData {
  self.chargeId = self.originData.chargeId;
  self.chargePrice = self.originData.price;
  self.coinCount = self.originData.money;
  self.des = self.originData.desc;
    self.payType = self.originData.payType;
    self.dayMoney = self.originData.dayMoney;
  self.type = self.originData.type;
    self.mark = self.originData.mark;
    NSInteger price = [self.originData.price integerValue];
//    if (self.originData.type == 1) {
//        // 钻石
//        self.appleProductId = [NSString stringWithFormat:@"diamond.%ld", price];
//    } else if (self.originData.type == 2) {
//        self.appleProductId = [NSString stringWithFormat:@"%ld", price];
//    }
    self.appleProductId = self.originData.iosOption;
}
- (void)configPointData {
  self.chargeId = self.originPointData.pmId;
  self.chargePrice = self.originPointData.points;
  self.coinCount = self.originPointData.goldCoin;
  self.des = @"";
  self.type = 10;
}
@end
