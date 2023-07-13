#import "PPRequestBaseModel.h"
#import "PPRechargeLogResponseModel.h"
@interface PPRechargeLogRequestModel : PPRequestBaseModel
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@end
