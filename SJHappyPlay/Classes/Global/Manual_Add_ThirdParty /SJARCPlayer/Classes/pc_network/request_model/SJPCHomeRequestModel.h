#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"
@interface SJPCHomeRequestModel : PPRequestBaseModel<SDRequestBaseProtocol>
@property (nonatomic, strong) NSString * page;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * type;
@end
