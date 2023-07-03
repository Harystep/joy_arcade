

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAExchangeModel : NSObject

@property (nonatomic, copy) NSString *exchangeId;
@property (nonatomic, copy) NSString *goldCoin;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *createTime;
@end

NS_ASSUME_NONNULL_END
