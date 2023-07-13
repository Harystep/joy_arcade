#import "PPBaseTcpData.h"
typedef enum : NSUInteger {
    SDMoveDirctionUp = 1,
    SDMoveDirctionDown,
    SDMoveDirctionLeft,
    SDMoveDirctionRight
} SDMoveDirctionType;
@interface PPTcpMoveDirctionData : PPBaseTcpData
@property (nonatomic, assign) SDMoveDirctionType direction;
- (instancetype)initWithVmc_no:(NSString *)vmc_no dirction:(SDMoveDirctionType)dirction;
- (instancetype)initWithVmc_no:(NSString *)vmc_no cmd:(NSString *)cmd_s dirction:(SDMoveDirctionType)dirction;
@end
