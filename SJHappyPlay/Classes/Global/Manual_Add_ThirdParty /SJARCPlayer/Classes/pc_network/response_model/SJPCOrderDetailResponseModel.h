#import "PPResponseBaseModel.h"
@class PCOrderDetailDataModel;
@interface SJPCOrderDetailResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCOrderDetailDataModel * data;
@end
@interface PCOrderDetailDataModel:NSObject
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * consignee;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * expressNo;
@property (nonatomic, strong) NSString * expressTime;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * orderSn;
@property (nonatomic, strong) NSArray * productList;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@end
