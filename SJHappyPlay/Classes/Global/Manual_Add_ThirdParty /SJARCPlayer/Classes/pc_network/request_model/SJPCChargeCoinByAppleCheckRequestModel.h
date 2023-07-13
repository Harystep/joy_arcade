#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface SJPCChargeCoinByAppleCheckRequestModel : PPRequestBaseModel
@property (nonatomic, strong) NSString * orderSn;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) NSString * receipt;
@end
NS_ASSUME_NONNULL_END
