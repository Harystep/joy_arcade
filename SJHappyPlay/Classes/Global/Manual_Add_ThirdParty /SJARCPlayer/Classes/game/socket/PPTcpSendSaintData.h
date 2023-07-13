#import "PPBaseTcpData.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPTcpSendSaintData : PPBaseTcpData
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger multiple;
- (instancetype)initWithVmc_no:(NSString *)vmc_no position:(NSInteger )position cmd:(NSString * )cmd;
@end
@interface SDTcpSendSaintCoinData: PPTcpSendSaintData
@property (nonatomic, assign) NSInteger isNewGame;
@end
@interface SDTcpSendSaintLeaveData : PPTcpSendSaintData
@property (nonatomic, assign) NSInteger isLeave;
@end
NS_ASSUME_NONNULL_END
