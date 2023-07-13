//
//  SDRechargeViewController.h
//  Pods
//
//  Created by sander shan on 2022/10/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SDRechargeType) {
    SDRechargeForDiamond = 1,
    SDRechargeForGold = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface SDRechargeViewController : UIViewController


@property (nonatomic, assign) SDRechargeType chargeType;


- (instancetype)initWithType:(SDRechargeType) type;


@end

NS_ASSUME_NONNULL_END
