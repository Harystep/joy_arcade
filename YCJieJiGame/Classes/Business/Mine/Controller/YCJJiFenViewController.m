//
//  YCJJiFenViewController.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/31.
//

#import "YCJJiFenViewController.h"
#import "YCJJinBiCell.h"
#import "YCJConsumeModel.h"

@interface YCJJiFenViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray    *jinFenList;
@property (nonatomic, assign) NSInteger         page;
@property (nonatomic, assign) NSString          *type;
@end

@implementation YCJJiFenViewController

- (NSMutableArray *)jinFenList {
    if (!_jinFenList) {
        _jinFenList = [NSMutableArray array];
    }
    return _jinFenList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bgImageWhite];
    [self configUI];
    self.type = @"2";
    self.page = 1;
    [self requestJiFenList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConsumeType:) name:YCJConsumeTypeModiyNotification object:nil];
}

- (void)reloadConsumeType:(NSNotification *)noti {
    self.type = noti.object;
    self.page = 1;
    [self requestJiFenList];
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}


- (void)requestJiFenList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKDollMoneyListUrlKey parameters:@{@"type": self.type,@"source": @"3", @"page": [NSString stringWithFormat:@"%ld", weakSelf.page], @"pageSize": @"20"} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            if(self.jinFenList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }else {
                [self showError:result.error];
            }
        }else {
            if(self.page == 1) { [self.jinFenList removeAllObjects]; }
            
            NSArray *list = [YCJConsumeModel mj_objectArrayWithKeyValuesArray:result.resultData[@"data"]];
            [self.jinFenList addObjectsFromArray:list];
            if(self.jinFenList.count == 0) {
                [self showError:nil];
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

- (void)showError:(NSError *)error {
    NSString *errorText = error.localizedDescription ?: @"暂无数据";
    WeakSelf
    if (error) {
        [self setupEmptyViewWithText:errorText isEmpty:!error action:^{
            StrongSelf
            [strongSelf requestJiFenList];
        }];
    }else{
        [self setupEmptyViewWithText:errorText isEmpty:!error action:nil];
        [self setEmptyViewTopOffset:-90];
        [self setEmptyViewBgColor:[UIColor clearColor]];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jinFenList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJJinBiCell *cell = [YCJJinBiCell cellWithTableView:tableView];
    cell.consumeModel = self.jinFenList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}

#pragma mark —— lazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = kSize(88);
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf requestJiFenList];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestJiFenList];
        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (UIView *)listView {
    return self.view;
}

@end
