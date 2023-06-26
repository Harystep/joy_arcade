//
//  YCJNewPlayerViewController.m
//  YCJieJiGame
//
//  Created by zza on 2023/6/4.
//

#import "YCJNewPlayerViewController.h"
#import "YCJNewPlayerCell.h"
#import "YCJNewPlayerModel.h"

@interface YCJNewPlayerViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) NSMutableArray        *playList;
@end

@implementation YCJNewPlayerViewController

- (NSMutableArray *)playList {
    if(!_playList) {
        _playList = [NSMutableArray array];
    }
    return _playList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZCLocalizedString(@"新手指导", nil);
    [self bgImageName:@"icon_mine_bg"];
    [self configUI];
    [self requestPlayList];
}

- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
    }];
};


- (void)requestPlayList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameIntroListUrlKey parameters:@{@"categoryId": @"0"} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.playList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        }else {
            self.playList = [YCJNewPlayerModel mj_objectArrayWithKeyValuesArray:result.resultData];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJNewPlayerCell *cell = [YCJNewPlayerCell cellWithTableView:tableView];
    cell.playModel = self.playList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCJNewPlayerModel *playModel = self.playList[indexPath.row];
    YCJBaseWebViewController *web = [[YCJBaseWebViewController alloc] init];
    web.url = playModel.url;
    web.navigationItem.title = playModel.title;
    [self.navigationController pushViewController:web animated:YES];
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
        _tableView.rowHeight = kSize(225);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
@end
