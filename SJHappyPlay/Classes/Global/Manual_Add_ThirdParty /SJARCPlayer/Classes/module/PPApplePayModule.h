#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^ApplyPayBlock)(NSString * receipt);
typedef void(^ApplePayFailBlock) (NSString * errMessage);
@interface PPApplePayModule : NSObject
@property (nonatomic, copy) ApplyPayBlock payBlock;
@property (nonatomic, copy) ApplePayFailBlock payFailBlock;
+ (instancetype)sharedInstance;
- (void)pay:(NSString *)projectId withOrderId:(NSString *)oriderId orderSn:(NSString *)orderSn withBlock:(ApplyPayBlock)block withFaileBlock:(ApplePayFailBlock)failBlock ;
- (void)finishTransactionForAp;
- (void)clearAllUncompleteTransaction:(ApplyPayBlock)block;
@end
NS_ASSUME_NONNULL_END
