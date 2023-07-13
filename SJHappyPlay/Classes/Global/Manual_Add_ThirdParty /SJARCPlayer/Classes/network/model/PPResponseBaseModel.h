#import <Foundation/Foundation.h>
#import "SDResponseBaseProtocol.h"
@interface PPResponseBaseModel : NSObject<SDResponseBaseProtocol>
@property (nonatomic, assign) NSNumber * errCode;
@property (nonatomic, strong) NSString * errMsg;
@end
