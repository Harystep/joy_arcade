#import <Foundation/Foundation.h>
#import "PPChargeUnitModel.h"
#import "SJPmPointResponseModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPChargetCoinData : NSObject
@property (nonatomic, strong) NSString * chargeId;
@property (nonatomic, strong) NSString * coinCount;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) NSString * chargePrice;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,copy) NSString *dayMoney;
@property (nonatomic,assign) NSInteger payType;

@property (nonatomic, assign) NSString * mark;
@property (nonatomic, strong) PPChargeUnitModel * originData;
@property (nonatomic, strong) SDPmPointUnitDataModel * originPointData;

@property (nonatomic, strong) NSString * appleProductId;

- (instancetype)initWithCoinData:(PPChargeUnitModel * )unit;
- (instancetype)initWithPmPointData:(SDPmPointUnitDataModel * )data;
@end
NS_ASSUME_NONNULL_END
