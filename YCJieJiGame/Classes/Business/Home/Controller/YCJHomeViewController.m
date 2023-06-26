//
//  YCJHomeViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJHomeViewController.h"
#import "YCJHomeLeftView.h"
#import "YCJHomeUserView.h"
#import "YCJHomeContentView.h"
#import "YCJGameRoomModel.h"

@interface YCJHomeViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) YCJHomeLeftView   *leftView;
@property (nonatomic, strong) YCJHomeUserView   *userView;
@property (nonatomic, strong) NSArray           *roomCategoryList;
@property (nonatomic, strong) UIScrollView      *scrollView;
@end

@implementation YCJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self bgimageGif:@"home.gif"];
    
    [self configUI];
    [self requestRoomList];
}

- (void)networkChange:(BOOL)net {
    if (net && self.roomCategoryList.count == 0) {
        [self requestRoomList];
    }
}

#pragma mark - loadData
- (void)requestRoomList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameRoomCategoryUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.roomCategoryList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        }else {
            self.roomCategoryList = [YCJGameRoomModel mj_objectArrayWithKeyValuesArray:result.resultData];
            [self gameContent];
        }
    }];
}

- (void)gameContent {
    //模拟数据源
    CGFloat h = kScreenHeight - 300;
    CGFloat w = kScreenWidth - 80 - 50;
    CGFloat pad = 10;
    for (int i = 0; i < self.roomCategoryList.count; i++) {
        YCJHomeContentView *content = [[YCJHomeContentView alloc] initWithFrame:CGRectMake(i * (w + pad), 0, w, h)];
        content.index = i;
        content.gameRoomModel = self.roomCategoryList[i];
        content.cornerRadius = kSize(10);
        _scrollView.contentSize = CGSizeMake((w + pad) * self.roomCategoryList.count, h);
        [_scrollView addSubview:content];
    }
}

- (void)configUI {
    
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
        make.height.mas_equalTo(kScreenHeight - 300);
    }];
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

@end
