#import "PPGameConfig.h"

#import "AppDefineHeader.h"
#import "PPNetworkConfig.h"

@implementation PPGameConfig
static PPGameConfig * instance;
+ (PPGameConfig * )sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPGameConfig alloc] init];
    });
    return instance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoPushCoin = true;
    }
    return self;
}

- (void)onShareWechatWithApp {
    if (self.configDelegate  && [self.configDelegate respondsToSelector:@selector(onShareWechatWithApp)]) {
        [self.configDelegate onShareWechatWithApp];
    }
}
- (void)onShareWechatSceneWithApp{
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(onShareWechatSceneWithApp)]) {
        [self.configDelegate onShareWechatSceneWithApp];
    }
}
- (void)goChargeForCoinInController:(UIViewController *)viewController{
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(goChargeForCoinInController:)]) {
        [self.configDelegate goChargeForCoinInController:viewController];
    }
}
- (void)goChargeForDiamondInController:(UIViewController *)viewController{
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(goChargeForDiamondInController:)]) {
        [self.configDelegate goChargeForDiamondInController:viewController];
    }
}
- (void)onGoToRankPageInController:(UIViewController *)viewController{
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(onGoToRankPageInController:)]) {
        [self.configDelegate onGoToRankPageInController:viewController];
    }
}
- (NSString *)getApplePayForChargeId {
    if (_applePayForChargeId) {
        return _applePayForChargeId;
    }
    return @"com.ydd.wawajiwetbysander";
}
- (void)configGame {    
    [PPNetworkConfig sharedInstance].base_request_url = @"https://api.ssjww100.com/api/";
      [PPNetworkConfig sharedInstance].base_my_host = @"47.103.68.250";
      [PPNetworkConfig sharedInstance].base_my_port = 56792;
      [PPNetworkConfig sharedInstance].export_review_date = @"2022-08-05";
}

@end
