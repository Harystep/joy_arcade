#import "PPBaseTcpData.h"
@interface PPTcpConnData : PPBaseTcpData
@property (nonatomic, strong) NSString * token;
- (instancetype)initWithToken:(NSString * )token Vmc_no:(NSString *)vmc_no NS_DESIGNATED_INITIALIZER;
@end
