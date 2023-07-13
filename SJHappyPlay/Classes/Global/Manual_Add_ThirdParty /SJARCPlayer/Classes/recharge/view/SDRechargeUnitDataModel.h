//
//  SDRechargeUnitDataModel.h
//  wawajiGame
//
//  Created by sander shan on 2022/10/14.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SDRechargeItemForType) {
    SDRechargeItemForDiamond = 1,
    SDRechargeItemGold = 2,
    SDRechargeItemCycle = 3,
};

@class PPChargeUnitModel;
@interface SDRechargeUnitDataModel : NSObject
@property (nonatomic, strong) PPChargeUnitModel * originData;

- (instancetype)initWithOriginData:(PPChargeUnitModel *) data;

@property (nonatomic, assign) SDRechargeItemForType chargeType;

@property (nonatomic, strong) NSString * exchangeValue;

@property (nonatomic, strong) NSString * priceValue;

@property (nonatomic, strong) NSString * exchangeRemark;

@property (nonatomic, strong) NSString * appleProductId;

@property (nonatomic, strong) NSString * mark;
@end

NS_ASSUME_NONNULL_END
