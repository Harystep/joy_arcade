//
//  YCJGameDetailViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJGameDetailViewController.h"
#import "YCJGameRecordCell.h"
#import "YCJGameDetailCell.h"

@interface YCJGameDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UIView                *footerView;
/// 左边文案
@property (nonatomic, strong) UILabel               *topLabel;
@property (nonatomic, strong) YCJGameRecordModel    *currentModel;
@property (nonatomic, strong) NSMutableArray        *detailList;
@end

@implementation YCJGameDetailViewController

- (NSMutableArray *)detailList {
    if (!_detailList) {
        _detailList = [NSMutableArray array];
    }
    return _detailList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游戏记录详情";
    [self bgImageWhite];
    [self configUI];
    [self requestGameDetail];
}

- (void)requestGameDetail {
    /// 机器类型 1：娃娃机 3,5都属于推币机 4,6都属于街机类型
    NSString *url = JKJieJISettleListUrlKey;
    if ([@[@"1", @"3", @"5"] containsObject:self.gameModel.type]) {
        url = JKTuiBiJiSettleListUrlKey;
    } else if ([@[@"4", @"6"] containsObject:self.gameModel.type]) {
        url = JKJieJISettleListUrlKey;
    }
    [JKNetWorkManager getRequestWithUrlPath:url parameters:@{@"id": self.gameModel.recordId} finished:^(JKNetWorkResult * _Nonnull result) {
        WeakSelf
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else {
            weakSelf.currentModel = [YCJGameRecordModel mj_objectWithKeyValues:result.resultData];
            weakSelf.detailList = [weakSelf.currentModel.list copy];
            if (weakSelf.detailList.count <= 0) {  /// 如果是推币机和娃娃机，没有单独的结算记录列表
                weakSelf.footerView.hidden = NO;
            } else {
                weakSelf.footerView.hidden = YES;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)complaintAction {
    //1.创建Controller
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    /*
     参数说明：
     Title:弹框的标题
     message:弹框的消息内容
     preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
     */
    NSArray *titles = @[@"画面黑屏或定格", @"操作按键失灵", @"其他原因"];
    
    for (int i = 0; i < titles.count; i++) {
        //2.添加按钮动作
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了项目:%@", titles[i]);
            WeakSelf
            [weakSelf submitShensu:titles[i]];
        }];
        [alertSheet addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    //3.添加动作
    [alertSheet addAction:cancel];
    
    //4.显示sheet
    [self presentViewController:alertSheet animated:YES completion:nil];
}

- (void)submitShensu:(NSString *)reason {
    if ([[JKTools handelString:self.gameModel.recordId] isEqualToString:@""]){
        [MBProgressHUD showError:@"结算id无效"];
        return;
    }
    /// 机器类型 1：娃娃机 3,5都属于推币机 4,6都属于街机类型
    NSString *url = JKJieJiGameShensuUrlKey;
    if ([@[@"1", @"3", @"5"] containsObject:self.gameModel.type]) {
        url = JKTuiBiJiGameShensuUrlKey;
    } else if ([@[@"4", @"6"] containsObject:self.gameModel.type]) {
        url = JKJieJiGameShensuUrlKey;
    }
    [JKNetWorkManager postRequestWithUrlPath:url parameters:@{@"id":self.gameModel.recordId, @"type":@"4", @"reason": reason} finished:^(JKNetWorkResult * _Nonnull result) {
        if(!result.error) {
            [MBProgressHUD showSuccess:@"申诉成功"];
        } else {
            [MBProgressHUD showSuccess:result.error.localizedDescription];
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
    } else {
        return self.detailList.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YCJGameRecordCell *cell = [YCJGameRecordCell cellWithTableView:tableView];
        cell.gameRecordModel = self.gameModel;
        return cell;
    } else {
        YCJGameDetailCell *cell = [YCJGameDetailCell cellWithTableView:tableView];
        cell.gameModel = self.gameModel;
        cell.detailModel = self.detailList[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSize(115);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && self.detailList.count > 0) {
        return 30;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && self.detailList.count > 0) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [head addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(kMargin);
            make.height.mas_equalTo(20);
        }];
        return head;
    } else {
        return [UIView new];
    }
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
        _tableView.tableFooterView = self.footerView;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        _footerView.hidden = YES;
        UIButton *footB = [[UIButton alloc] init];
        [footB setTitle:@"结算申诉" forState:UIControlStateNormal];
        [footB setBackgroundColor:kColorHex(0x6984EA)];
        footB.cornerRadius = kSize(8);
        [footB addTarget:self action:@selector(complaintAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:footB];
        [footB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMargin);
            make.right.mas_equalTo(-kMargin);
            make.height.mas_equalTo(kSize(50));
            make.top.mas_equalTo(kSize(15));
        }];
    }
    return _footerView;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = kPingFangSemiboldFont(14);
        _topLabel.textColor = kCommonBlackColor;
        _topLabel.text = @"结算记录";
        _topLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _topLabel;
}

@end
