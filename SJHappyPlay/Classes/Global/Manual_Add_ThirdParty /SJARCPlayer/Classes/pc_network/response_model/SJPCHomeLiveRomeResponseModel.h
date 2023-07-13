#import <Foundation/Foundation.h>
#import "PPHomeLiveRoomUnitDataModel.h"
@interface SJPCHomeLiveRomeResponseModel : NSObject
@property (nonatomic, strong) NSArray <PPHomeLiveRoomUnitDataModel * > * data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPages;
@end
