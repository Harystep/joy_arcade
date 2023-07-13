//
//  SDRechargeUnitDataModel.m
//  wawajiGame
//
//  Created by sander shan on 2022/10/14.
//

#import "SDRechargeUnitDataModel.h"

#import "PPChargeUnitModel.h"
#import "PPNetworkConfig.h"
@implementation SDRechargeUnitDataModel

- (instancetype)initWithOriginData:(PPChargeUnitModel *) data
{
    self = [super init];
    if (self) {
        _originData = data;
        [self configData];
    }
    return self;
}
- (void)configData {
    NSInteger price = [self.originData.price integerValue];
    if (self.originData.type) {
        if (self.originData.type == 1) {
            // 钻石
            self.chargeType = SDRechargeItemForDiamond;
//            self.appleProductId = [NSString stringWithFormat:@"diamond.%ld", price];
        } else if (self.originData.type == 2) {
            self.chargeType = SDRechargeItemGold;
//            self.appleProductId = [NSString stringWithFormat:@"%ld", price];
        }
        
        self.appleProductId = self.originData.iosOption;
        self.exchangeValue = self.originData.money;
        self.priceValue = self.originData.price;
        self.exchangeRemark = self.originData.desc;
    } else {
        // 周卡，月卡
        self.chargeType = SDRechargeItemCycle;
        self.exchangeValue = self.originData.title;
        self.exchangeRemark = self.originData.desc;
        self.priceValue = self.originData.price;
//        self.appleProductId = [NSString stringWithFormat:@"%ld", price];
    }
    self.mark = self.originData.mark;
}

@end
