#import "PPResponseBaseModel.h"
@class PCBallListDataModel;
@interface SJPCBallListResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCBallListDataModel * data;
@end
@interface PCBallListDataModel:NSObject
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger expressMoney;
@property (nonatomic, assign) NSInteger total;
@end
