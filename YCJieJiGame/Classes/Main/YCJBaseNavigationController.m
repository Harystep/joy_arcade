//
//  YCJBaseNavigationController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJBaseNavigationController.h"

@interface YCJBaseNavigationController ()

@end

@implementation YCJBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
