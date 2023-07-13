//
//  SDAlertShowManager.h
//  ZhuaWaWa
//
//  Created by shansander on 2018/1/26.
//  Copyright © 2018年 李昀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDAlertShowManager : NSObject
+ (void)showSystemSureAlertinViewController:(UIViewController * )targetController Title:(NSString * )title Message:(NSString * )message handler:(void (^ __nullable)(UIAlertAction *action))handler;
@end
