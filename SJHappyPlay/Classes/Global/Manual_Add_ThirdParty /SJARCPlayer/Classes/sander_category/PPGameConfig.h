#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol SDGameConfigContentDelegate <NSObject>
- (void)onShareWechatWithApp;
- (void)onShareWechatSceneWithApp;
- (void)goChargeForCoinInController:(UIViewController *)viewController;
- (void)goChargeForDiamondInController:(UIViewController *)viewController;
- (void)onGoToRankPageInController:(UIViewController *)viewController;
@end
@interface PPGameConfig : NSObject
@property (nonatomic, weak) id<SDGameConfigContentDelegate> configDelegate;
@property (nonatomic, strong) NSString * applePayForChargeId;

/// 是否需要自动 上币
@property (nonatomic, assign) Boolean autoPushCoin;

+ (PPGameConfig * )sharedInstance;
- (void)onShareWechatWithApp;
- (void)onShareWechatSceneWithApp;
- (void)goChargeForCoinInController:(UIViewController *)viewController;
- (void)goChargeForDiamondInController:(UIViewController *)viewController;
- (void)onGoToRankPageInController:(UIViewController *)viewController;
- (NSString *)getApplePayForChargeId;
- (void)configGame;
@end
NS_ASSUME_NONNULL_END
