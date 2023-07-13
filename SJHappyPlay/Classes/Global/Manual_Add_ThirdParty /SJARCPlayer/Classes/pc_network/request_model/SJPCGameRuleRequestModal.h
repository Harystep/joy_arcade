#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"
#import "SJPCGameRuleResponseModal.h"
NS_ASSUME_NONNULL_BEGIN
@interface SJPCGameRuleRequestModal : PPRequestBaseModel<SDRequestBaseProtocol>
@property (nonatomic, strong) NSString * machineSn;
@end
NS_ASSUME_NONNULL_END
