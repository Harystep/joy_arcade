#import "PPResponseBaseModel.h"
#import "SJPCLoginWeiXinResponseModel.h"
@interface SJPCWeiXinLoginResponseModel : PPResponseBaseModel<SDResponseBaseProtocol>
@property (nonatomic, strong) SJPCLoginWeiXinResponseModel * data;
@end
