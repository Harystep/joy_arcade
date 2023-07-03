

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN
// 积分兑换金币
@class QAExchangeModel;
@interface QAExchangeCoinsAlertView : QABaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(QAExchangeCoinsAlertView *, QAExchangeModel *);
@property(nonatomic, strong) QAExchangeModel *exchangeModel;
@property(nonatomic, strong) NSString *zuanshi;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
