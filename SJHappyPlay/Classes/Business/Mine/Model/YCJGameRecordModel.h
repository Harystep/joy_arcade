

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJGameDetailModel : NSObject
@property(nonatomic,copy) NSString *detailId;
@property(nonatomic,copy) NSString *dollLogId;
@property(nonatomic,copy) NSString *memberId;
@property(nonatomic,copy) NSString *machineId;
@property(nonatomic,copy) NSString *localUrl;
@property(nonatomic,copy) NSString *points;
@property(nonatomic,copy) NSString *machineType;
@property(nonatomic,copy) NSString *updateTime;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *deleted;
@end

@interface YCJGameRecordModel : NSObject
@property(nonatomic,copy) NSString *recordId;
@property(nonatomic,copy) NSString *points;
@property(nonatomic,copy) NSString *roomImg;
@property(nonatomic,copy) NSString *roomName;
@property(nonatomic,copy) NSString *status;
// 机器类型 1：娃娃机 3,5都属于推币机 4,6都属于街机类型
// 3: 推币机 4：街机 5：钻石推币机 6：金币传说
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,strong) NSArray<YCJGameDetailModel *> *list;
@end

NS_ASSUME_NONNULL_END
