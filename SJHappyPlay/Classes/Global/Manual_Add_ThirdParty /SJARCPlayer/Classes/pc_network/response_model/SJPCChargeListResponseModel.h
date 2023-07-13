#import "PPResponseBaseModel.h"
#import "PPChargeUnitModel.h"
@class PCChargeTypeInfoModel;
@interface SJPCChargeListResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCChargeTypeInfoModel * data;
@end
@interface PCChargeTypeInfoModel: NSObject
@property (nonatomic, strong) NSArray * chargeOptions;
//@property (nonatomic, assign) NSInteger showV;
//@property (nonatomic, assign) NSInteger otherPayFlag;
@property (nonatomic, strong) NSArray<PPChargeUnitModel *> * optionList;
//@property (nonatomic, strong) NSArray<PPChargeUnitModel *> * month;
//@property (nonatomic, strong) NSArray<PPChargeUnitModel *> * week;
@property (nonatomic, strong) PPChargeUnitModel * week;
@property (nonatomic, strong) PPChargeUnitModel * month;
@property (nonatomic, strong) PPChargeUnitModel * first;
@property (nonatomic, strong) PPChargeUnitModel * daily_first_recharge;
@property (nonatomic,strong) NSArray *paySupport;

@end;
