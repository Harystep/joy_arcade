

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJComplaintAppeal : NSObject

@property(nonatomic,assign) NSInteger status;
@property(nonatomic,copy) NSString  *reason;

@end

@interface YCJComplaintSettleLog : NSObject

@property(nonatomic,copy) NSString  *logId;
@property(nonatomic,copy) NSString  *dollLogId;
@property(nonatomic,copy) NSString  *memberId;
@property(nonatomic,copy) NSString  *appealId;
@property(nonatomic,copy) NSString  *machineId;
@property(nonatomic,copy) NSString  *localUrl;
@property(nonatomic,copy) NSString  *points;
@property(nonatomic,copy) NSString  *machineType;
@property(nonatomic,copy) NSString  *updateTime;
@property(nonatomic,copy) NSString  *createTime;
@property(nonatomic,copy) NSString  *deleted;

@end

@interface YCJComplaintDetailModel : NSObject
@property(nonatomic,copy) NSString  *complaintId;
@property(nonatomic,assign) NSInteger  status;
@property(nonatomic,copy) NSString  *createTime;
@property(nonatomic,strong) YCJComplaintAppeal *appeal;
@property(nonatomic,copy) NSString  *type;
@property(nonatomic,copy) NSString  *roomName;
@property(nonatomic,copy) NSString  *points;
@property(nonatomic,copy) YCJComplaintSettleLog  *settleLog;
@end

@interface YCJComplaintModel : NSObject
@property(nonatomic,copy) NSString  *complaintId;
@property(nonatomic,copy) NSString  *status;
@property(nonatomic,copy) NSString  *createTime;
@property(nonatomic,assign) NSInteger appealStatus;
@property(nonatomic,copy) NSString  *roomImg;
@property(nonatomic,copy) NSString  *roomName;
@property(nonatomic,copy) NSString  *points;
@property(nonatomic,copy) NSString  *type;
@end

NS_ASSUME_NONNULL_END
