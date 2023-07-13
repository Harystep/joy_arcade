#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SDGameRuleModal;
@interface SJPCGameRuleResponseModal : PPResponseBaseModel
@property (nonatomic, strong) SDGameRuleModal * data;
@end
@interface SDGameRuleModal : NSObject
@property (nonatomic, strong) NSString * rule;
@end
NS_ASSUME_NONNULL_END
