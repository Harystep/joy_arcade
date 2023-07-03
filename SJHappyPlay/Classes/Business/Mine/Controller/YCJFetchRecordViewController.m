

#import "YCJFetchRecordViewController.h"
#import "YCJFetchRecordCell.h"
#import "YCJFetchRecordModel.h"

@interface YCJFetchRecordViewController ()
<UITableViewDataSource,
UITableViewDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *fetchList;
@property (nonatomic, assign) NSInteger         page;
@end

@implementation YCJFetchRecordViewController

- (NSMutableArray *)fetchList {
    if(!_fetchList) {
        _fetchList = [NSMutableArray array];
    }
    return _fetchList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"抓取记录", nil);
    [self bgImageWhite];;
    [self configUI];
    [self requestFetchList];
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
    }];
}

- (void)requestFetchList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKFetchListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            if(self.fetchList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }else {
                [self showError:result.error];
            }
        }else {
            if(self.page == 1) { [self.fetchList removeAllObjects]; }
            
            NSArray *list = [YCJFetchRecordModel mj_objectArrayWithKeyValuesArray:result.resultData[@"rows"]];
           
            [self.fetchList addObjectsFromArray:list];
            if(self.fetchList.count == 0) {
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
    NSString *errorText = error.localizedDescription ?: ZCLocalizedString(@"暂无数据", nil);
    WeakSelf
    if (error) {
        [self setupEmptyViewWithText:errorText isEmpty:!error action:^{
            StrongSelf
            [strongSelf requestFetchList];
        }];
    }else{
        [self setupEmptyViewWithText:errorText isEmpty:!error action:nil];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJFetchRecordCell *cell = [YCJFetchRecordCell cellWithTableView:tableView];
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
        _tableView.rowHeight = kSize(120);
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf requestFetchList];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestFetchList];
        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

@end
