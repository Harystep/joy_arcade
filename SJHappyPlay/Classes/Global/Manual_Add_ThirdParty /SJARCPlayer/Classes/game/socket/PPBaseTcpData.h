#import <Foundation/Foundation.h>
@interface PPBaseTcpData : NSObject
@property (nonatomic, strong) NSString * cmd;
@property (nonatomic, strong) NSString * vmc_no;
@property (nonatomic, assign) NSInteger type;
- (NSData * )getSendData;
- (instancetype)initWithVmc_no:(NSString *)vmc_no ;
- (instancetype)initWithVmc_no:(NSString *)vmc_no cmd:(NSString * )cmd_s NS_DESIGNATED_INITIALIZER;
@end
