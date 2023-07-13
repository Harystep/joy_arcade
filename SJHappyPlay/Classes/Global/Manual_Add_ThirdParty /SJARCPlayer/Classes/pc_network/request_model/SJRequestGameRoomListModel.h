

#import "PPRequestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJRequestGameRoomListModel : PPRequestBaseModel<SDRequestBaseProtocol>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *machineType;

@end

NS_ASSUME_NONNULL_END
