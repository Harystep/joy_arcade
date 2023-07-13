//
//  SDGameModule.m
//  wawajiGame
//
//  Created by sander shan on 2023/2/21.
//

#import "SDGameModule.h"

#import "SJWawajiGameViewController.h"
#import "SJPushCoinGameViewController.h"
#import "SJSaintsGameViewController.h"
#import "SJGoldLegendViewController.h"
#import "PPGameConfig.h"
#import "PPImageUtil.h"
#import "SDRechargeViewController.h"
#import "SDGameDefineHeader.h"

@interface SDGameModule ()<SDGameConfigContentDelegate>

@end

@implementation SDGameModule

static SDGameModule * gameModule;
+ (SDGameModule * )get_Instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameModule = [[SDGameModule alloc] init];
    });
    return gameModule;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameModule = [super allocWithZone:zone];
    });
    return gameModule;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)presentViewController:(NSString *)machineSn roomId:(NSString *)roomId machineType:(NSInteger)machineType inRootController:(UIViewController *) viewController {
    
    [PPGameConfig sharedInstance].configDelegate = [SDGameModule get_Instance];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
        if (viewController != nil) {
            rootViewController = viewController;
        }
        if (machineType == game_type_pushCoin || machineType == game_type_pushCoin_for_money) {
          SJPushCoinGameViewController * pushCoinViewController = [[SJPushCoinGameViewController alloc] init];
          pushCoinViewController.machineSn = machineSn;
            pushCoinViewController.room_id = roomId;
          pushCoinViewController.modalPresentationStyle = UIModalPresentationFullScreen;
          [rootViewController presentViewController:pushCoinViewController animated:NO completion:nil];
          return;
        } else if (machineType == game_type_saint) {
          SJSaintsGameViewController * staintsGameViewController = [[SJSaintsGameViewController alloc] init];
          staintsGameViewController.machineSn = machineSn;
            staintsGameViewController.room_id = roomId;
          staintsGameViewController.modalPresentationStyle =UIModalPresentationFullScreen;
          [rootViewController presentViewController:staintsGameViewController animated:NO completion:nil];
          return;
        } else if (machineType == game_type_goldLegend) {
          SJGoldLegendViewController * pushCoinViewController = [[SJGoldLegendViewController alloc] init];
          pushCoinViewController.machineSn = machineSn;
            pushCoinViewController.room_id = roomId;
          pushCoinViewController.modalPresentationStyle =UIModalPresentationFullScreen;
          [rootViewController presentViewController:pushCoinViewController animated:NO completion:nil];
          return;
        }
        SJWawajiGameViewController * viewController = [[SJWawajiGameViewController alloc] init];
        viewController.machineSn = machineSn;
        viewController.room_id = roomId;
        viewController.modalPresentationStyle =  UIModalPresentationFullScreen;
        [rootViewController presentViewController:viewController animated:NO completion:nil];
    });
}

#pragma mark - SDGameConfigContentDelegate
- (void)goChargeForCoinInController:(UIViewController *)viewController {
    SDRechargeViewController * rechargeViewController = [[SDRechargeViewController alloc] initWithType:SDRechargeForGold];
    UINavigationController * rootViewController = [[UINavigationController alloc] initWithRootViewController:rechargeViewController];
    [viewController presentViewController:rootViewController animated:true completion:nil];
}
- (void)goChargeForDiamondInController:(UIViewController *)viewController {
    SDRechargeViewController * rechargeViewController = [[SDRechargeViewController alloc] initWithType:SDRechargeForDiamond];
    UINavigationController * rootViewController = [[UINavigationController alloc] initWithRootViewController:rechargeViewController];
    [viewController presentViewController:rootViewController animated:true completion:nil];
}
@end
