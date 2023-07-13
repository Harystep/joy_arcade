#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
  device_wawaji = 1,
  device_pushCoin = 3,
  device_staints = 4,
    device_pushCoin_for_money = 5,
    device_goldLegend = 6,
} SDDeviceType;
NS_ASSUME_NONNULL_BEGIN
@interface PPHomeLiveRoomUnitDataModel : NSObject
@property (nonatomic, strong)NSString * channelKey1;
@property (nonatomic, strong) NSString *  channelKey2;
@property (nonatomic, strong) NSArray<NSString *> * imgs;
@property (nonatomic, strong) NSString * liveRoom1;
@property (nonatomic, strong) NSString * liveRoom2;
@property (nonatomic, strong) NSString * machineId;
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * winImg;
@property (nonatomic, strong) NSString * liveRoomCode;
@property (nonatomic, strong) NSString * texture;
@property (nonatomic, assign) SDDeviceType type;
@property (nonatomic, strong) NSString * gameUrl;
@property (nonatomic, strong) NSString * profileUrl;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger cameraA;
@property (nonatomic, assign) NSInteger cameraB;
@property (nonatomic, assign) NSInteger machineType;

@property (nonatomic, assign) NSInteger isEnter;
// 当前 房间的 游玩的位置
@property (nonatomic, strong) NSArray<NSNumber *> * positions;

@property (nonatomic, strong) NSString * roomImg;

@property (nonatomic, assign) NSInteger player;

@property (nonatomic, assign) NSInteger fixStatus;

@property (nonatomic, strong) NSString * roomName;

@end
NS_ASSUME_NONNULL_END
