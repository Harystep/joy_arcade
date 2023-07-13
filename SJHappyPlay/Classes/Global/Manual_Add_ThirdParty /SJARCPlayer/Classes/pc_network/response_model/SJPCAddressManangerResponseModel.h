#import "PPResponseBaseModel.h"
@class PCAddressManangerListModel;
@interface SJPCAddressManangerResponseModel : PPResponseBaseModel
@property(nonatomic, strong) PCAddressManangerListModel * data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPages;
@end
@interface PCAddressManangerListModel:NSObject
@property (nonatomic, strong)NSArray * data;
@end
