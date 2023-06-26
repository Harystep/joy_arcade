//
//  YCJComplaintDetailViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJComplaintDetailViewController.h"
#import "YCJGameRecordCell.h"
#import "YCJComplaintDetailCell.h"
#import "YCJComplaintModel.h"

@interface YCJComplaintDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) YCJComplaintDetailModel *resultModel;

@end

@implementation YCJComplaintDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申诉详情";
    [self bgImageWhite];
    [self configUI];
    [self requestComplaintDetail];
}

- (void)requestComplaintDetail {
    [JKNetWorkManager getRequestWithUrlPath:JKGameShensuDetailUrlKey parameters:@{@"id": self.comModel.complaintId} finished:^(JKNetWorkResult * _Nonnull result) {
        WeakSelf
        [weakSelf.tableView.mj_header endRefreshing];
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else {
            weakSelf.resultModel = [YCJComplaintDetailModel mj_objectWithKeyValues:result.resultData];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
        make.bottom.mas_equalTo(-kSafeAreaBottomHeight);
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YCJGameRecordCell *cell = [YCJGameRecordCell cellWithTableView:tableView];
        cell.comModel = self.comModel;
        return cell;
    } else {
        YCJComplaintDetailCell *cell = [YCJComplaintDetailCell cellWithTableView:tableView];
        [cell detailModel:self.resultModel index:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kSize(120);
    } else {
        return kSize(94);
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        WeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestComplaintDetail];
        }];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

@end
