//
//  YCJTabBarController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJTabBarController.h"

#import "YCJShopViewController.h"
#import "YCJConversionCentreViewController.h"
#import "YCJHomeViewController.h"
#import "YCJRankViewController.h"
#import "YCJMineViewController.h"

#import "YCJBaseViewController.h"
#import "YCJBaseNavigationController.h"

#import "YCJTabBar.h"
#import <AVFoundation/AVFoundation.h>

@interface YCJTabBarController ()
<
UITabBarControllerDelegate
>
@property(nonatomic, assign) NSInteger selected;
@property(nonatomic, strong) YCJTabBar *tabView;

@end

@implementation YCJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    self.delegate = self;
    [self setValue:self.tabView forKeyPath:@"tabBar"];
    self.selected = 2;
    self.selectedIndex = self.selected;
    self.tabView.current = self.selected;
    [self addObserver:self forKeyPath:@"self.selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{  //需要执行的方法
        WeakSelf
        weakSelf.tabView.current = [[change valueForKey:@"new"] intValue];
    });
}


- (void)setupViewControllers{

    [self addControllerWithClass:[YCJShopViewController class] title:@" " nomalImage:@"icon_tab_sc_en" selectImage:@"icon_tab_sc_en" index:0];
    
    [self addControllerWithClass:[YCJConversionCentreViewController class] title:@" " nomalImage:@"icon_tab_dhzx_en" selectImage:@"icon_tab_dhzx_en" index:1];
   
    [self addControllerWithClass:[YCJHomeViewController class] title:@" " nomalImage:@"icon_tab_zhuye_en" selectImage:@"icon_tab_zhuye_en" index:2];
 
    [self addControllerWithClass:[YCJRankViewController class] title:@" " nomalImage:@"icon_tab_phb_en" selectImage:@"icon_tab_phb_en" index:3];
   
    [self addControllerWithClass:[YCJMineViewController class] title:@" " nomalImage:@"icon_tab_grzs_en" selectImage:@"icon_tab_grzs_en" index:4];
    
}

- (void)addControllerWithClass:(Class)class
                         title:(NSString *)title
                    nomalImage:(NSString *)nomalImage
                   selectImage:(NSString *)selectImage
                         index:(NSInteger)index{
    YCJBaseViewController *controller = (YCJBaseViewController *)[[class alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:nomalImage] tag:index];
    [item setSelectedImage:[UIImage imageNamed:selectImage]];
    controller.tabBarItem = item;
    controller.title = title;
    YCJBaseNavigationController *nav = [[YCJBaseNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.tabView.current = viewController.tabBarItem.tag;
    return YES;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self playSoundBackground];
}

- (void)playSoundBackground {
    
    //1. 创建another SystemSoundID
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"tab_clicked.aac" withExtension:nil];
    CFURLRef urlRef = (__bridge CFURLRef)url;
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID(urlRef, &soundID);
    // 2. 播放
    AudioServicesPlaySystemSound(soundID);
}

- (YCJTabBar *)tabView {
    if (!_tabView) {
        _tabView = [[YCJTabBar alloc] init];
    }
    return _tabView;
}

@end
