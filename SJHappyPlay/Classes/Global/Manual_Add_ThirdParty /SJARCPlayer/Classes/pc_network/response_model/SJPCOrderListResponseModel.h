#import "PPResponseBaseModel.h"
@class PCOrderProductListModel;
@interface SJPCOrderListResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCOrderProductListModel * data;
@end
@interface PCOrderProductListModel:NSObject
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPages;
@end
