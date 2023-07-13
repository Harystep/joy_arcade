//
//  SDTabRechargeViewController.m
//  wawajiGame
//
//  Created by sander shan on 2023/3/9.
//

#import "SDTabRechargeViewController.h"

#import "SDRechargeViewController.h"

#import "PPImageUtil.h"

#import "UIColor+MCUIColorsUtils.h"

@interface SDTabRechargeViewController ()

//@property (nonatomic, weak)

@end

@implementation SDTabRechargeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
//        self.showOnNavigationBar = true;
        self.progressWidth = 27;
        self.progressViewIsNaughty = true;
        self.progressHeight = 3.5;
        self.progressViewCornerRadius = 3.5;
        self.titleColorSelected = [UIColor colorForHex:@"#333333"];
        self.titleColorNormal = [UIColor colorForHex:@"#333333CC"];
        self.progressColor = [UIColor colorForHex:@"#333333"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)configView {
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[PPImageUtil getImage:@"ico_navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction)];
    }
    self.title = @"充值";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"充值明细" style:UIBarButtonItemStylePlain target:self action:@selector(onRechargeLogTap)];
    
//    self.navigationItem.rightBarButtonItem
}


- (void)onBackAction {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)onRechargeLogTap {
    
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 2) {
        case 1:
            return @"钻石";
            break;
        case 0:
            return @"金币";
            break;
        default:
            return nil;
            break;
    }
}
- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 2) {
        case 1: return [[SDRechargeViewController alloc] initWithType:SDRechargeForDiamond];
        case 0: return [[SDRechargeViewController alloc] initWithType:SDRechargeForGold];
    }
    return [[UIViewController alloc] init];
}


@end
