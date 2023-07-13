#import "PPGameGoodDetailView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "SJPageTabbarView.h"
#import "PPWawajiDetailViewController.h"
#import "PPRecentlyCateLogViewController.h"

#import "AppDefineHeader.h"

@interface PPGameGoodDetailView ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, weak) SJPageTabbarView * tabbarView;
@property (nonatomic, weak) UIScrollView * thePageViewController;
@property (nonatomic, strong) NSArray<UIViewController * > * viewControllerList;
@end
@implementation PPGameGoodDetailView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEH_HEIGHT);
    self.theActionSubject = [RACSubject subject];
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  self.backgroundColor = [UIColor whiteColor];
  UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(SF_Float(20), SF_Float(20))];
  CAShapeLayer * mask_layer = [CAShapeLayer layer];
  mask_layer.path = path.CGPath;
  mask_layer.frame = self.bounds;
  self.layer.mask = mask_layer;
  [self tabbarView];
  [self thePageViewController];
}
#pragma mark - set
- (void)setImgs:(NSArray *)imgs {
  PPWawajiDetailViewController * detailViewController = (PPWawajiDetailViewController * )self.viewControllerList[0];
  detailViewController.imgs = imgs;
}
- (void)setMachineSn:(NSString *)machineSn {
  _machineSn = machineSn;
  PPRecentlyCateLogViewController * viewController = (PPRecentlyCateLogViewController * )self.viewControllerList[1];
  viewController.machineSn = machineSn;
}
#pragma mark - action
- (void)changeTab:(NSInteger)tab {
  if (tab == 0) {
    PPWawajiDetailViewController * viewController = (PPWawajiDetailViewController *)self.viewControllerList[0];
    [viewController showView];
  } else {
    PPRecentlyCateLogViewController * viewController = (PPRecentlyCateLogViewController * )self.viewControllerList[1];
    [viewController showView];
  }
  self.tabbarView.currentTab = tab;
  [self.thePageViewController setContentOffset:CGPointMake(self.bounds.size.width * tab, 0) animated:true];
}
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  return nil;
}
#pragma mark - lazy UI
- (SJPageTabbarView * )tabbarView{
  if (!_tabbarView) {
    SJPageTabbarView * theView = [[SJPageTabbarView alloc] initWithTab:@[@"娃娃详情",@"最近抓中"]];
    [self addSubview:theView];
    @weakify(self);
    [theView.tabSubject subscribeNext:^(id  _Nullable x) {
      @strongify(self);
      NSInteger tabIndex = [x integerValue];
      [self changeTab:tabIndex];
    }];
    _tabbarView = theView;
  }
  return _tabbarView;
}
- (UIScrollView * )thePageViewController{
  if (!_thePageViewController) {
    UIScrollView * theView = [[UIScrollView alloc] init];
    [self addSubview:theView];
    theView.frame = CGRectMake(0, SF_Float(100), SCREEN_WIDTH, SCREEH_HEIGHT - SF_Float(100));
    PPWawajiDetailViewController * wawajiDetailViewController = [[PPWawajiDetailViewController alloc] init];
    wawajiDetailViewController.theActionSubject = self.theActionSubject;
    [theView addSubview:wawajiDetailViewController.view];
    wawajiDetailViewController.view.frame = CGRectMake(0, 0, theView.bounds.size.width, theView.bounds.size.height);
    PPRecentlyCateLogViewController * cateLogViewController = [[PPRecentlyCateLogViewController alloc] init];
    cateLogViewController.theActionSubject = self.theActionSubject;
    [theView addSubview:cateLogViewController.view];
    cateLogViewController.view.frame = CGRectMake(theView.bounds.size.width, 0, theView.bounds.size.width, theView.bounds.size.height);
    self.viewControllerList = @[wawajiDetailViewController, cateLogViewController];
    theView.scrollEnabled = false;
    theView.showsHorizontalScrollIndicator = false;
    _thePageViewController = theView;
  }
  return _thePageViewController;
}
@end
