//
//  SDAlertShowManager.m
//  ZhuaWaWa
//
//  Created by shansander on 2018/1/26.
//  Copyright © 2018年 李昀. All rights reserved.
//

#import "SDAlertShowManager.h"

@implementation SDAlertShowManager

+ (void)showSystemSureAlertinViewController:(UIViewController * )targetController Title:(NSString * )title Message:(NSString * )message handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * sure_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:sure_action];
    
    [targetController presentViewController:alert animated:YES completion:nil];
}

@end
