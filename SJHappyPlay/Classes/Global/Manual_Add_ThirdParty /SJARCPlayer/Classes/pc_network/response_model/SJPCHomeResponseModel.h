#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"
#import "SJPCHomeLiveRomeResponseModel.h"
@interface SJPCHomeResponseModel : PPResponseBaseModel<SDResponseBaseProtocol>
@property (nonatomic, strong) SJPCHomeLiveRomeResponseModel * data;
@end
