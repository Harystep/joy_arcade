#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN
@class SDPMPointChargeInfo;
@interface SJPmPointResponseModel : PPResponseBaseModel
@property (nonatomic, strong) SDPMPointChargeInfo * data;
@end
@interface SDPMPointChargeInfo: NSObject
@property (nonatomic, strong) NSString * points;
@property (nonatomic, strong) NSArray * list;
@end
@interface SDPmPointUnitDataModel: NSObject
@property (nonatomic, strong) NSString * pmId;
@property (nonatomic, strong) NSString * goldCoin;
@property (nonatomic, strong) NSString * points;
@end
NS_ASSUME_NONNULL_END
