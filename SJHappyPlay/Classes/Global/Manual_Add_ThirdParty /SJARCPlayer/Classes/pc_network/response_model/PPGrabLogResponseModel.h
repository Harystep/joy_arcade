#import "PPResponseBaseModel.h"
@class SDGrabLogListModel;
@interface PPGrabLogResponseModel : PPResponseBaseModel
@property (nonatomic, strong) SDGrabLogListModel * data;
@end
@interface SDGrabLogListModel: PPResponseBaseModel
@property (nonatomic, strong) NSArray *  data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@end
