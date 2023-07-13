#import "PPRequestBaseModel.h"
@interface SJPCAddNewAddressRequestModel : PPRequestBaseModel
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * consignee;
@property (nonatomic, strong) NSString * address_id;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, strong) NSString * mobile;
@end
