
#import "KMHomeViewController.h"
#import "YCJHomeLeftView.h"
#import "YCJHomeUserView.h"
#import "KMHomeContentView.h"
#import "YCJGameRoomModel.h"
#import "FLAnimatedImageView+WebCache.h"

@interface KMHomeViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) YCJHomeLeftView   *leftView;
@property (nonatomic, strong) YCJHomeUserView   *userView;
@property (nonatomic, strong) NSArray           *roomCategoryList;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic,strong) FLAnimatedImageView *animalIv;//动画视图
@end

@implementation KMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self bgimageGif:@"home.gif"];
    self.setupNavigationBarHidden = YES;
    [self configUI];
    [self requestRoomList];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kUserLoginSuckey object:nil];
}

- (void)networkChange:(BOOL)net {
    if (net && self.roomCategoryList.count == 0) {
        [self requestRoomList];
    }
}

- (void)refreshData {
    [self requestRoomList];
}

#pragma mark - loadData
- (void)requestRoomList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameRoomCategoryUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.roomCategoryList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        } else {
            self.roomCategoryList = [YCJGameRoomModel mj_objectArrayWithKeyValuesArray:result.resultData];
            [self gameContent];
        }
    }];
}

- (void)gameContent {
   
    NSInteger maxCount = 0;
    for (int i = 0; i < self.roomCategoryList.count; i++) {
        YCJGameRoomModel *game = self.roomCategoryList[i];
        if (game.roomGroupList.count > maxCount) {
            maxCount = game.roomGroupList.count;
        }
    }
    CGFloat h = kScreenHeight - 200 - kTabBarHeight - 10;
    CGFloat target = (GameButtonHeight + 10) * maxCount + 80 + 220;
    if (h > target) {
        h = target;
    }
    CGFloat w = kScreenWidth - 80 - 50;
    CGFloat pad = 10;
   
    for (int i = 0; i < self.roomCategoryList.count; i++) {
        KMHomeContentView *content = [[KMHomeContentView alloc] initWithFrame:CGRectMake(i * (w + pad), 0, w, h)];
        content.index = i;
        content.gameRoomModel = self.roomCategoryList[i];
        content.cornerRadius = kSize(10);
        _scrollView.contentSize = CGSizeMake((w + pad) * self.roomCategoryList.count, h);
        [_scrollView addSubview:content];
    }
}

- (void)configUI {
    
//    [self.view addSubview:self.animalIv];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"home" ofType:@"gif"];
//    NSData *imageData = [NSData dataWithContentsOfFile:path];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
//    self.animalIv.animatedImage = image;
    
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kSize(60 + kMargin));
    }];
    
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kSize(100));
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(kScreenWidth - 80);
        make.height.mas_equalTo(kScreenHeight - 200 - kTabBarHeight - 10);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.leftView showSignInAlertView];
    });
    
    
}

#pragma mark - scrollview的代理方法，此方法在拖动scrollview时就会调用
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = kScreenWidth - 80 - 50;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

#pragma mark -
#pragma mark -- lazy load
- (YCJHomeUserView *)userView {
    if (!_userView) {
        _userView = [[YCJHomeUserView alloc] init];
    }
    return _userView;
}

- (YCJHomeLeftView *)leftView {
    if (!_leftView) {
        _leftView = [[YCJHomeLeftView alloc] init];
    }
    return _leftView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        // 设置scrollview的可视范围
        _scrollView.frame = CGRectMake(80, 200, kScreenWidth - 80, kScreenHeight - 300);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (FLAnimatedImageView *)animalIv {
    if (!_animalIv) {
        _animalIv = [[FLAnimatedImageView alloc] init];
        _animalIv.frame = UIScreen.mainScreen.bounds;
    }
    return _animalIv;
}

@end
