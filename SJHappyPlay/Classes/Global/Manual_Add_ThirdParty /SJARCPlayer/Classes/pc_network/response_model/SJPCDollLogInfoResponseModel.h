#import "PPResponseBaseModel.h"
@class PCDollLogInfoResponseData;
@class PCDollLogInfoResponseAppeal;
@interface SJPCDollLogInfoResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCDollLogInfoResponseData * data;
@end
@interface PCDollLogInfoResponseData : NSObject
@property (nonatomic, strong) PCDollLogInfoResponseAppeal * appeal;
@property (nonatomic, strong) NSString *  createTime;
@property (nonatomic, strong) NSString *  p_id;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, assign) NSInteger status;
@end
@interface PCDollLogInfoResponseAppeal:NSObject
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * result;
@end;
