#import "PPResponseBaseModel.h"
@class PCEnterRoomDataModel;
@class PCLiveRoomDataModel;
@interface SJPCEnterRoomResponseModel : PPResponseBaseModel
@property (nonatomic, strong) PCEnterRoomDataModel * data;
@end
@interface PCEnterRoomDataModel : NSObject
@property (nonatomic, strong) NSString * roomId;
@property (nonatomic, strong) PCLiveRoomDataModel * liveRoom1;
@property (nonatomic, strong) PCLiveRoomDataModel * liveRoom2;
@end
@interface PCLiveRoomDataModel : NSObject
@property (nonatomic, strong) NSString * channelKey;
@property (nonatomic, strong) NSString * room;
@end
