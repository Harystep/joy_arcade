#import "PPResponseBaseModel.h"
#import "SJPCLoginWeiXinResponseModel.h"
@interface SJPCRefreshTokenResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCLoginAccessTokenResponseModel * data;
@end
