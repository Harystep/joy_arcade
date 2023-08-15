

#import "QATabBarController.h"

#import "YCJShopViewController.h"
#import "QAConversionCentreViewController.h"
#import "KMHomeViewController.h"
#import "YCJRankViewController.h"
#import "YCJMineViewController.h"
#import "YCJHomeViewController.h"
#import "QABaseViewController.h"
#import "QABaseNavigationController.h"
#import "YCJTabHotViewController.h"
#import "QATabBar.h"
#import <AVFoundation/AVFoundation.h>

@interface QATabBarController ()
<
UITabBarControllerDelegate
>
@property(nonatomic, assign) NSInteger selected;
@property(nonatomic, strong) QATabBar *tabView;

@end

@implementation QATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    self.delegate = self;
    [self setValue:self.tabView forKeyPath:@"tabBar"];

    self.selectedIndex = self.selected;
    self.tabView.current = self.selected;
    [self addObserver:self forKeyPath:@"self.selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchItemType:) name:@"kSwitchTabItemKey" object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{  //需要执行的方法
        WeakSelf
        weakSelf.tabView.current = [[change valueForKey:@"new"] intValue];
    });
}


- (void)setupViewControllers{
//    YCJHomeViewController
//    KMHomeViewController
//    [self addControllerWithClass:[KMHomeViewController class] titleStr:@"" nomalImage:@"icon_tab_zhuye_en" selectImage:@"icon_tab_zhuye_en" index:0];
    [self addControllerWithClass:[YCJHomeViewController class] titleStr:@"" nomalImage:@"icon_tab_zhuye_en" selectImage:@"icon_tab_zhuye_en" index:0];
//    YCJRankViewController
    [self addControllerWithClass:[YCJTabHotViewController class] titleStr:@"" nomalImage:@"icon_tab_phb_en" selectImage:@"icon_tab_phb_en" index:1];
    
//    [self addControllerWithClass:[QAConversionCentreViewController class] titleStr:@"" nomalImage:@"icon_tab_dhzx_en" selectImage:@"icon_tab_dhzx_en" index:2];
    
    [self addControllerWithClass:[YCJShopViewController class] titleStr:@"" nomalImage:@"icon_tab_sc_en" selectImage:@"icon_tab_sc_en" index:2];
   
    [self addControllerWithClass:[YCJMineViewController class] titleStr:@"" nomalImage:@"icon_tab_grzs_en" selectImage:@"icon_tab_grzs_en" index:3];
    
}

- (void)addControllerWithClass:(Class)class
                         titleStr:(NSString *)titleStr
                    nomalImage:(NSString *)nomalImage
                   selectImage:(NSString *)selectImage
                         index:(NSInteger)index{
    QABaseViewController *controller = (QABaseViewController *)[[class alloc] init];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleStr image:[UIImage imageNamed:nomalImage] tag:index];
    [item setSelectedImage:[UIImage imageNamed:selectImage]];
    controller.tabBarItem = item;
    controller.title = titleStr;
    QABaseNavigationController *nav = [[QABaseNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.tabView.current = viewController.tabBarItem.tag;
    if(viewController.tabBarItem.tag < 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"kTabItemClickKey%tu", viewController.tabBarItem.tag] object:[NSString stringWithFormat:@"%tu", viewController.tabBarItem.tag]];
    }
    return YES;
}

- (void)switchItemType:(NSNotification *)noti {
    self.selectedIndex = [noti.object integerValue];
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

- (QATabBar *)tabView {
    if (!_tabView) {
        _tabView = [[QATabBar alloc] init];
    }
    return _tabView;
}

@end
