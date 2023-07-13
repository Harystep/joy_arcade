#import <UIKit/UIKit.h>
@protocol SDSaintPushCoinViewDelegate <NSObject>
- (void)pushCoinWithCoinCount:(NSInteger)count;
@end
NS_ASSUME_NONNULL_BEGIN
@interface PPSaintPushCoinView : UIView
@property (nonatomic, weak) id<SDSaintPushCoinViewDelegate> pushCoinDelegate;
- (void)showButtons;
- (void)hideButtons;
@end
NS_ASSUME_NONNULL_END
