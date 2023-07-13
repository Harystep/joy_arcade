#import "PPBaseTcpData.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPTcpSendPushCoinData : PPBaseTcpData
@property (nonatomic, assign) NSInteger coin;
- (instancetype)initWithVmc_no:(NSString *)vmc_no coin:(NSInteger)coin;
@end
NS_ASSUME_NONNULL_END
