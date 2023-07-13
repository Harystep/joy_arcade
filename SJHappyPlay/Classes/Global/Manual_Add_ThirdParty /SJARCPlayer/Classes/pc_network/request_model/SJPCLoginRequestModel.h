#import "PPRequestBaseModel.h"
@interface SJPCLoginRequestModel : PPRequestBaseModel<SDRequestBaseProtocol>
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, assign) NSInteger platform;
@end
