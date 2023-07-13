#import "PPRequestBaseModel.h"
@interface SJPCChargeRequestModel : PPRequestBaseModel
@property (nonatomic, strong) NSString * b_id;
@property (nonatomic, assign) NSString *  tradeType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * returnUrl;
@end
