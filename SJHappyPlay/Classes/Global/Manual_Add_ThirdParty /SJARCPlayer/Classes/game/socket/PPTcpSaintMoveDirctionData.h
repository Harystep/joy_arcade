#import "PPBaseTcpData.h"
#import "PPTcpMoveDirctionData.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPTcpSaintMoveDirctionData : PPBaseTcpData
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) SDMoveDirctionType direction;
- (instancetype)initWithStopVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion;
- (instancetype)initWithVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion;
- (instancetype)initWithSimpleVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction postion:(NSInteger) postion;
@end
NS_ASSUME_NONNULL_END
