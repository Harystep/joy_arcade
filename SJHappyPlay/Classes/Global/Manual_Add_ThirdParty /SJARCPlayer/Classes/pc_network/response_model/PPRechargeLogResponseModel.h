#import "PPResponseBaseModel.h"
@class SDRechargeLogResponseDataModel;
@interface PPRechargeLogResponseModel : PPResponseBaseModel
@property (nonatomic, strong) SDRechargeLogResponseDataModel * data;
@end
@interface SDRechargeLogResponseDataModel :NSObject
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page_size;
@end
