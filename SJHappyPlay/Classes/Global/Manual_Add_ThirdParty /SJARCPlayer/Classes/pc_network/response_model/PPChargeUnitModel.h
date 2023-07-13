#import <Foundation/Foundation.h>
//#import <MJExtension/MJExtension.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN
@interface PPChargeUnitModel : NSObject
@property (nonatomic, strong) NSString * chargeId;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * mark;
@property (nonatomic, strong) NSString * profitRate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger is_recharged;
@property (nonatomic, strong) NSString * iosOption;
@property (nonatomic,copy) NSString *dayMoney;
@property (nonatomic,assign) NSInteger payType;
@end
NS_ASSUME_NONNULL_END
