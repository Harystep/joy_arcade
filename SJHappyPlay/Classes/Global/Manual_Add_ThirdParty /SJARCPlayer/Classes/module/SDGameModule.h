//
//  SDGameModule.h
//  wawajiGame
//
//  Created by sander shan on 2023/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDGameModule : NSObject

+ (void)presentViewController:(NSString *)machineSn roomId:(NSString *)roomId machineType:(NSInteger)machineType inRootController:(UIViewController *) viewController;
@end

NS_ASSUME_NONNULL_END
