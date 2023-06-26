//
//  YCJGameRecordViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/19.
//

#import "YCJGameRecordViewController.h"
#import "YCJGameRecordCell.h"
#import "YCJGameDetailViewController.h"
#import "YCJGameRecordModel.h"

@interface YCJGameRecordViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *recordList;
@property (nonatomic, assign) NSInteger         page;
@end

@implementation YCJGameRecordViewController

- (NSMutableArray *)recordList {
    if(!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游戏记录";
    self.page = 1;
    [self bgImageWhite];
    [self configUI];
    [self requestGameList];
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
    }];
}

- (void)requestGameList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKGameListUrlKey parameters:@{@"type": @"2", @"page": [NSString stringWithFormat:@"%ld", weakSelf.page], @"pageSize": @"20"} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            if(self.recordList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }else {
                [self showError:result.error];
            }
        }else {
            if(self.page == 1) { [self.recordList removeAllObjects]; }
            
            NSArray *list = [YCJGameRecordModel mj_objectArrayWithKeyValuesArray:result.resultData[@"data"]];
           
            [self.recordList addObjectsFromArray:list];
            if(self.recordList.count == 0) {
                [self showError:nil];
            } else {
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
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
            [strongSelf requestGameList];
        }];
    }else{
        [self setupEmptyViewWithText:errorText isEmpty:!error action:nil];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJGameRecordCell *cell = [YCJGameRecordCell cellWithTableView:tableView];
    cell.gameRecordModel = self.recordList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCJGameRecordModel *game = self.recordList[indexPath.row];
    YCJGameDetailViewController *vc = [[YCJGameDetailViewController alloc] init];
    vc.gameModel = game;
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.rowHeight = kSize(115);
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf requestGameList];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestGameList];
        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
@end
