#import <UIKit/UIKit.h>
#import "PPChargetCoinData.h"
#import "ReactiveObjC.h"
typedef enum : NSUInteger {
  SDChargeInGameForCoin,
  SDChargeInGameForCoinByPoint,
} SDChargeInGameForMethod;
@protocol SDChargeInGameViewDelegate <NSObject>
- (void)dissmissChargeController;
@end
NS_ASSUME_NONNULL_BEGIN
@interface PPChargeInGameView : UIView
@property (nonatomic, assign) SDChargeInGameForMethod chargeForMethod;
@property (nonatomic, strong) NSString * currentPriceValue;
@property (nonatomic, strong) NSString * currentPointValue;
@property (nonatomic, strong) NSString * currentStoneValue;
@property (nonatomic, strong) NSArray<PPChargetCoinData * > * chargeList;
@property (nonatomic, strong) RACSubject * chargetSubject;
@property (nonatomic, weak) id<SDChargeInGameViewDelegate> delegate;
- (void)showChargeInGame;
- (void)showChargeAliPayData:(NSString *) data;
@end
NS_ASSUME_NONNULL_END
