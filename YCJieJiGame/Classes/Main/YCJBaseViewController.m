//
//  YCJBaseViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJBaseViewController.h"

#import "YCJBaseNavigationController.h"
#import "JKEmptyView.h"
#import "Reachability.h"
#import "UIImage+GIF.h"

@interface YCJBaseViewController ()
<
UIGestureRecognizerDelegate
>

@property(nonatomic, strong) JKEmptyView *emptyView;
@property(nonatomic, strong) UIButton *goBackBtn;
@property(nonatomic, strong) Reachability *reach;

@end

@implementation YCJBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorRGB(254, 254, 254);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonWhiteColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    if(self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    }
    [self.view addSubview:self.bgImageOne];
    self.bgImageOne.layer.zPosition = 0;
    self.reach = [Reachability reachabilityForInternetConnection];
    WeakSelf
    self.reach.reachableBlock = ^(Reachability *reachability) {
        [weakSelf networkChange:YES];
    };
    self.reach.unreachableBlock = ^(Reachability*reach) {
        [weakSelf networkChange:NO];
    };
    // Start the notifier, which will cause the reachability object to retain itself!
    [self.reach startNotifier];
}

- (void)networkChange:(BOOL)net {}

- (void)bgimageGif:(NSString *)named {
    self.bgImageOne.hidden = NO;
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:named ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    self.bgImageOne.image = [UIImage sd_imageWithGIFData:imageData];
}

- (void)bgImageName:(NSString *)named {
    self.bgImageOne.hidden = NO;
    self.bgImageOne.image = [UIImage imageNamed:named];
}

- (void)bgImageWhite {
    [self bgImageName:@"icon_vc_background"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonBlackColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    if(self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.goBackBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.setupNavigationBarHidden animated:true];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.setupNavigationBarHidden animated:true];
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupEmptyViewWithText:(NSString *)text imageName:(NSString *)name isEmpty:(BOOL)isEmpty action:(void(^)(void))action {
    [self setupEmptyViewInView:nil image:name text:text isEmpty:isEmpty action:action];
}

- (void)setupEmptyViewWithText:(NSString *)text isEmpty:(BOOL)isEmpty action:(void(^)(void))action {
    [self setupEmptyViewInView:nil image:@"icon_empty" text:text isEmpty:isEmpty action:action];
}

- (void)setupEmptyViewInView:(UIView *)view text:(NSString *)text isEmpty:(BOOL)isEmpty action:(void(^)(void))action {
    [self setupEmptyViewInView:view image:@"icon_empty" text:text isEmpty:isEmpty action:action];
}

- (void)setupEmptyViewInView:(UIView *)view image:(NSString *)name text:(NSString *)text isEmpty:(BOOL)isEmpty action:(void(^)(void))action {
    if(view) {
        [view addSubview:self.emptyView];
        [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    if(action) {
        [self.emptyView setupText:text image:[UIImage imageNamed:name] actionTitle:ZCLocalizedString(@"重新加载", nil) action:action];
    }else {
        [self.emptyView setupText:text image:[UIImage imageNamed:name]];
    }
}

- (void)setEmptyViewBgColor:(UIColor *)emptyViewBgColor {
    [self.emptyView setEmptyBgColor:emptyViewBgColor];
}

- (void)setEmptyContentViewBgColor:(UIColor *)emptyContentViewBgColor {
    [self.emptyView setContentBgViewColor:emptyContentViewBgColor];
}

- (void)setEmptyTextColor:(UIColor *)emptyTextColor {
    [self.emptyView setTextColor:emptyTextColor];
}

- (void)setEmptyViewTopOffset:(CGFloat)emptyViewTopOffset {
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emptyViewTopOffset);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)removeEmptyView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}

- (UIButton *)goBackBtn {
    if (!_goBackBtn) {
        _goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_goBackBtn setImage:[[UIImage imageNamed:@"icon_nav_back"] imageChangeColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [_goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBackBtn;
}

- (JKEmptyView *)emptyView {
    if(!_emptyView) {
        _emptyView = [[JKEmptyView alloc] init];
        _emptyView.backgroundColor = kColorHex(0xF5F5F5);
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _emptyView;
}

- (UIImageView *)bgImageOne {
    if (!_bgImageOne) {
        _bgImageOne = [[UIImageView alloc] init];
        _bgImageOne.frame = UIScreen.mainScreen.bounds;
        _bgImageOne.hidden = YES;
    }
    return _bgImageOne;
}

@end
