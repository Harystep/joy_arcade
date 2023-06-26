//
//  YCJRankViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJRankViewController.h"
#import "YCJRankTopView.h"
#import "YCJRankBottomView.h"
#import "YCJRankCell.h"
#import "YCJRankListModel.h"
#import "YCJRankSelectedView.h"

@interface YCJRankViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) YCJRankTopView        *topView;
@property (nonatomic, strong) YCJRankBottomView     *bottomView;
@property (nonatomic, strong) YCJRankSelectedView   *rankSelectedView;
@property (nonatomic, strong) NSMutableArray        *rankList;
@property (nonatomic, strong) NSMutableArray        *caifuList;
@property (nonatomic, assign) NSInteger             page;
@property (nonatomic, assign) BOOL                  selectedRank;
@property (nonatomic, strong) YCJRankListModel      *myRankModel;
@property (nonatomic, strong) YCJRankListModel      *myCaifuModel;

@end

@implementation YCJRankViewController

- (NSMutableArray *)rankList {
    if(!_rankList) {
        _rankList = [NSMutableArray array];
    }
    return _rankList;
}

- (NSMutableArray *)caifuList {
    if(!_caifuList) {
        _caifuList = [NSMutableArray array];
    }
    return _caifuList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"排行榜", nil);
    [self bgImageName:@"icon_mine_bg"];
    [self configUI];
    
    self.selectedRank = YES;
    self.topView.hidden = YES;
    self.rankSelectedView.hidden = YES;
    [self requestRankList];
    [self requestCaifuList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:YCJUserInfoModiyNotification object:nil];
}

- (void)reload {
    [self requestRankList];
    [self requestCaifuList];
}

- (void)configUI {
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.rankSelectedView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + kSize(15));
        make.left.right.equalTo(self.view);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(70);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    [self.rankSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(550);
    }];
    self.tableView.layer.zPosition = 999;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankSelectedView.mas_top).offset(60);
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)networkChange:(BOOL)net {
    if (net && self.rankList.count == 0) {
        [self requestRankList];
        [self requestCaifuList];
    }
    if (net) {
        [self removeEmptyView];
    } else {
        [self showError:ZCLocalizedString(@"网络异常，请稍后重试", nil)];
    }
}

- (void)showError:(NSString *)errorText {
    WeakSelf
    [self setupEmptyViewWithText:errorText imageName:@"icon_net_error_a" isEmpty:YES action:^{
        StrongSelf
        [strongSelf requestRankList];
        [strongSelf requestCaifuList];
    }];
    self.topView.hidden = YES;
    self.rankSelectedView.hidden = YES;
    [self setEmptyViewTopOffset:30];
    [self setEmptyViewBgColor:[UIColor clearColor]];
    [self setEmptyContentViewBgColor:[UIColor clearColor]];
    [self setEmptyTextColor:kColorHex(0x7986B3)];
}

- (void)requestRankList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKJifenRankUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            [self showError:ZCLocalizedString(@"网络异常，请稍后重试", nil)];
        }else {
            if(self.page == 1) { [self.rankList removeAllObjects]; }
            NSArray *list = [YCJRankListModel mj_objectArrayWithKeyValuesArray:result.resultData[@"list"]];
            self.myRankModel = [YCJRankListModel mj_objectWithKeyValues:result.resultData[@"my"]];
            if (self.selectedRank) {
                self.bottomView.myRank = self.myRankModel;
            }
            self.topView.hidden = NO;
            self.rankSelectedView.hidden = NO;
            [self.rankList addObjectsFromArray:list];
            if (self.rankList.firstObject) {
                self.topView.rankModel = self.rankList.firstObject;
            }
            if(self.rankList.count == 0) {
            }else{
                [self removeEmptyView];
                [self.tableView reloadData];
                NSString *pages = [result.resultData objectForKey:@"pages"];
                if(pages) {
                    if (self.page >= pages.intValue) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        [self.tableView.mj_footer resetNoMoreData];
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                self.page++;
            }
        }
    }];
}

- (void)requestCaifuList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKChongzhiRankUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            if(self.caifuList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        }else {
            if(self.page == 1) { [self.caifuList removeAllObjects]; }
            NSArray *list = [YCJRankListModel mj_objectArrayWithKeyValuesArray:result.resultData[@"list"]];
            self.myCaifuModel = [YCJRankListModel mj_objectWithKeyValues:result.resultData[@"my"]];
            if (!self.selectedRank) {
                self.bottomView.myRank = self.myCaifuModel;
            }
            self.topView.hidden = NO;
            self.rankSelectedView.hidden = NO;
            [self.caifuList addObjectsFromArray:list];
            if (self.caifuList.firstObject) {
                self.topView.caifuModel = self.caifuList.firstObject;
            }
            if(self.caifuList.count == 0) {
            }else{
                [self removeEmptyView];
                [self.tableView reloadData];
                NSString *pages = [result.resultData objectForKey:@"pages"];
                if(pages) {
                    if (self.page >= pages.intValue) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        [self.tableView.mj_footer resetNoMoreData];
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                self.page++;
            }
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedRank) {
        return self.rankList.count;
    } else {
        return self.caifuList.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJRankCell *cell = [YCJRankCell cellWithTableView:tableView];
    if (self.selectedRank) {
        cell.rankModel = self.rankList[indexPath.row];
    } else {
        cell.rankModel = self.caifuList[indexPath.row];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //圆率
    CGFloat cornerRadius = 12;
    //大小
    CGRect bounds = cell.bounds;
    //行数
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    UIView *headerView;
    if ([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        headerView=[self tableView:tableView viewForHeaderInSection:indexPath.section];
    }
    
    //绘制曲线
    UIBezierPath *bezierPath = nil;
    if (headerView) {
        if (indexPath.row == 0 && numberOfRows == 1) {
            //一个为一组时，四个角都为圆角
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }else
        if (indexPath.row == numberOfRows - 1) {
            //为组的最后一行，左下、右下角为圆角
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        } else {
            //中间的都为矩形
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }else{
        if (indexPath.row == 0 && numberOfRows == 1) {
            //一个为一组时，四个角都为圆角
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        } else if (indexPath.row == 0) {
            //为组的第一行时，左上、右上角为圆角
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        } else if (indexPath.row == numberOfRows - 1) {
            //为组的最后一行，左下、右下角为圆角
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        } else {
            //中间的都为矩形
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
    
    //新建一个图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    //图层边框路径
    layer.path = bezierPath.CGPath;
    cell.layer.mask=layer;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    //圆率
    CGFloat cornerRadius = 12;
    //大小
    CGRect bounds = view.bounds;
    
    //绘制曲线
    UIBezierPath *bezierPath = nil;
    //为组的第一行时，左上、右上角为圆角
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    //新建一个图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    //图层边框路径
    layer.path = bezierPath.CGPath;
    view.layer.mask=layer;
}

#pragma mark —— lazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSize(60);
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            if (weakSelf.selectedRank) {
                [weakSelf requestRankList];
            } else {
                [weakSelf requestCaifuList];
            }
        }];
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            if (weakSelf.selectedRank) {
//                [weakSelf requestRankList];
//            } else {
//                [weakSelf requestCaifuList];
//            }
//        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (YCJRankTopView *)topView {
    if (!_topView) {
        _topView = [[YCJRankTopView alloc] init];
    }
    return _topView;
}

- (YCJRankSelectedView *)rankSelectedView {
    if (!_rankSelectedView) {
        _rankSelectedView = [[YCJRankSelectedView alloc] init];
        _rankSelectedView.backgroundColor = kColorHex(0x5C79B7);
        _rankSelectedView.cornerRadius = 12;
        WeakSelf
        _rankSelectedView.commonAlertViewDoneClickBlock = ^(NSInteger flag) {
            NSLog(@"hhh:%ld", flag);
            if (flag == 2) { /// 大师
                weakSelf.selectedRank = YES;
                weakSelf.bottomView.myRank = weakSelf.myRankModel;
            } else {    /// 财富
                weakSelf.selectedRank = NO;
                weakSelf.bottomView.myRank = weakSelf.myCaifuModel;
            }
            [weakSelf.tableView reloadData];
        };
    }
    return _rankSelectedView;
}

- (YCJRankBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[YCJRankBottomView alloc] init];
    }
    return _bottomView;
}

@end
