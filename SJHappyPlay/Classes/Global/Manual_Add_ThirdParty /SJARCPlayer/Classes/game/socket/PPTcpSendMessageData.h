#import "PPBaseTcpData.h"
@interface PPTcpSendMessageData : PPBaseTcpData
@property (nonatomic, strong) NSString * content;
- (instancetype)initWithVmc_no:(NSString *)vmc_no content:(NSString * )content;
@end
