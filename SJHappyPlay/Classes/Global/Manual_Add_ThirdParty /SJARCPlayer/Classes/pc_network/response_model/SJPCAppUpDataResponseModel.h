#import "PPResponseBaseModel.h"
@class PCAppUpDataResponseData;
@interface SJPCAppUpDataResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCAppUpDataResponseData * data;
@end
@interface PCAppUpDataResponseData : NSObject
@property (nonatomic, assign) NSInteger ios_update;
@property (nonatomic, strong) NSString * mesage;
@end
