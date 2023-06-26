//
//  YCJInAppPurchase.h
//  YCJieJiGame
//
//  Created by John on 2023/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJInAppPurchase : NSObject
- (id)init;

//发起内购
- (void)launchInAppPurchase:(NSString *)productId;

//恢复内购
- (void)resumeInAppPurchase:(NSString *)productId;
//
- (void)removeObserver;

@end

NS_ASSUME_NONNULL_END
