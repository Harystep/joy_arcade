#import "PPRequestBaseModel.h"
#import "SDRequestBaseProtocol.h"
@interface PPRequestTestDataModel : PPRequestBaseModel<SDRequestBaseProtocol>
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * age;
@end
