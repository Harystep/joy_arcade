
#import "PPResponseBaseModel.h"
@class SJGameRoomListInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SJResponseGameRoomListModel : PPResponseBaseModel

@property (nonatomic, strong) NSArray<SJGameRoomListInfoModel *> *data;


@end

//@interface SJGameRoomListInfoModel : NSObject
//
//@property (nonatomic,copy) NSString *roomId;
//@property (nonatomic,copy) NSString *roomName;
//@property (nonatomic,copy) NSString *roomImg;
//@property (nonatomic,copy) NSString *machineId;
//@property (nonatomic,copy) NSString *machineSn;
//@property (nonatomic,copy) NSString *status;
//@property (nonatomic,copy) NSString *machineType;
//@property (nonatomic,copy) NSString *minLevel;
//@property (nonatomic,copy) NSString *minGold;
//@property (nonatomic,copy) NSString *multiple;
//@property (nonatomic,copy) NSString *sort;
//@property (nonatomic,copy) NSString *cost;
//@property (nonatomic,copy) NSString *player;
//@property (nonatomic,copy) NSString *costType;
//
//@end

NS_ASSUME_NONNULL_END
