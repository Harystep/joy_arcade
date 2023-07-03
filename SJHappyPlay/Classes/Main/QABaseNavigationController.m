

#import "QABaseNavigationController.h"

@interface QABaseNavigationController ()

@end

@implementation QABaseNavigationController

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
