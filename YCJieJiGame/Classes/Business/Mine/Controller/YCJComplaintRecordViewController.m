//
//  YCJComplaintRecordViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/19.
//

#import "YCJComplaintRecordViewController.h"
#import "YCJComplaintDetailViewController.h"
#import "YCJComplainRecordCell.h"
#import "YCJComplaintModel.h"

@interface YCJComplaintRecordViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray    *complaintList;
@property (nonatomic, assign) NSInteger         page;
@end

@implementation YCJComplaintRecordViewController

- (NSMutableArray *)complaintList {
    if(!_complaintList) {
        _complaintList = [NSMutableArray array];
    }
    return _complaintList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"申诉记录", nil);
    self.page = 1;
    [self bgImageWhite];
    [self configUI];
    [self requestComplainList];
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
    }];
}

- (void)requestComplainList {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKGameShensuListUrlKey parameters:@{@"page": [NSString stringWithFormat:@"%ld", weakSelf.page], @"pageSize": @"20"} finished:^(JKNetWorkResult * _Nonnull result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (result.error) {
            if(self.complaintList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            } else {
                [self showError:result.error];
            }
        } else {
            if(self.page == 1) { [self.complaintList removeAllObjects]; }
            
            NSArray *list = [YCJComplaintModel mj_objectArrayWithKeyValuesArray:result.resultData[@"data"]];
           
            [self.complaintList addObjectsFromArray:list];
            if(self.complaintList.count == 0) {
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
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
            [strongSelf requestComplainList];
        }];
    }else{
        [self setupEmptyViewWithText:errorText isEmpty:!error action:nil];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.complaintList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJComplainRecordCell *cell = [YCJComplainRecordCell cellWithTableView:tableView];
    cell.comModel = self.complaintList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCJComplaintModel *cmodel = self.complaintList[indexPath.row];
    if (cmodel.appealStatus == 0) { /// 申诉中，不可点击
        return;
    }
    YCJComplaintDetailViewController *vc = [[YCJComplaintDetailViewController alloc] init];
    vc.comModel = cmodel;
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
        _tableView.rowHeight = kSize(120);
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf requestComplainList];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestComplainList];
        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

@end
