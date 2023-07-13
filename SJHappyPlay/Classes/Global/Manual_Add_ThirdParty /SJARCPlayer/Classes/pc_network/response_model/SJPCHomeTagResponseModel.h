#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"
@interface SJPCHomeTagResponseModel : PPResponseBaseModel<SDResponseBaseProtocol>
@property (nonatomic, strong) NSArray * data;
@end


@interface SDWaWaPageViewModel : NSObject

@property (nonatomic, assign) NSInteger tag_id;

@property (nonatomic, strong) NSString * name;

@property (nonatomic, assign) NSInteger style;

@end
