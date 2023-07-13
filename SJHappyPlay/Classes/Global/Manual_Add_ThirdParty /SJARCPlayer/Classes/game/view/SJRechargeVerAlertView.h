
#import <UIKit/UIKit.h>
#import "SJUserRechargeCoinDataView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SJRechargeVerAlertViewDelegate <NSObject>
- (void)dissmissChargeController;
- (void)showChargeAliPayViewData:(NSString *)data;
- (void)paySuccessStatus;

@end

@interface SJRechargeVerAlertView : UIView

@property (nonatomic,strong) SJUserRechargeCoinDataView *coinDataView;

@property (nonatomic, weak) id<SJRechargeVerAlertViewDelegate> delegate;

- (void)showChargeAliPayWebView:(NSString *)data;

@end

NS_ASSUME_NONNULL_END
