#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface SJPutMachineWarningRequestModel : PPRequestBaseModel
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, strong) NSString * warningStatus;
- (instancetype)initWithmachineSn:(NSString *)sn;
@end
NS_ASSUME_NONNULL_END
