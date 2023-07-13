#import "PPResponseBaseModel.h"
@class PCSignListDataModel;
@interface SJPCSignListResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCSignListDataModel * data;
@end
@interface PCSignListDataModel :NSObject
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, assign) NSInteger status;
@end
