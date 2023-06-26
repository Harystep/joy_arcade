//
//  YCJMineViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJMineViewController.h"
#import "YCJMineHeaderView.h"
#import "YCJMineInfoModel.h"
#import "YCJMineListCell.h"
#import "YCJLoginViewController.h"
#import "YCJGameRecordViewController.h"
#import "YCJFetchRecordViewController.h"
#import "YCJComplaintRecordViewController.h"
#import "YCJSettingViewController.h"
#import "YCJRealNameAlertView.h"
#import "YCJNickNameModifyView.h"
#import "YCJInvitationCodeAlertView.h"
#import "YCJConsumeViewController.h"
#import "YCJInvitationViewController.h"
#import "YCJInviteCodeModel.h"
#import "YCJUserInfoModel.h"

@interface YCJMineViewController ()
<UITableViewDataSource,
UITableViewDelegate>
/// 头部视图
@property (nonatomic, strong) YCJMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <YCJMineInfoModel *> *dataMuArr;
@property (nonatomic, strong) YCJUserInfoModel *userInfo;
@end

@implementation YCJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"个人中心", nil);
    [self bgImageName:@"icon_mine_bg"];
    
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self checkLogin]) {
        [self loadUserInfo];
    }
}

- (void)configUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(kTabBarHeight);
    }];
   
    self.tableView.tableHeaderView = self.headerView;

}

#pragma mark - loadData
- (void)loadUserInfo {
    WeakSelf
    [JKNetWorkManager getRequestWithUrlPath:JKHuiyuanDetailUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        StrongSelf
        if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
            [YCJUserInfoManager sharedInstance].userInfoModel = [YCJUserInfoModel mj_objectWithKeyValues:result.resultData];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - 检查登录
#pragma mark -- checkLogin
- (BOOL)checkLogin {
    return [[YCJUserInfoManager sharedInstance] isLogin];
}

#pragma mark - 前往登录
#pragma mark -- goToLoginVC
- (void)goToLoginVC{
    YCJLoginViewController *vc = [[YCJLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMuArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJMineListCell *cell = [YCJMineListCell cellWithTableView:tableView];
    cell.mineInfoModel = [self.dataMuArr objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self checkLogin]) {
        YCJMineInfoModel *info = [self.dataMuArr objectAtIndex:indexPath.row];
        if(info.destinationClass) {
            [self.navigationController pushViewController:[info.destinationClass new] animated:YES];
        }else if(info.actionBlock) {
            info.actionBlock(info);
        }
    }else{
        [self goToLoginVC];
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSize(56);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (YCJMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YCJMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        WeakSelf
        _headerView.mineHeaderViewHeadImageClickBlock = ^{
            if ([weakSelf checkLogin]) {
            }else{
                [weakSelf goToLoginVC];
            }
        };
        _headerView.mineHeaderViewLoginClickBlock = ^{
            [weakSelf goToLoginVC];
        };
    }
    return _headerView;
}

- (NSMutableArray<YCJMineInfoModel *> *)dataMuArr{
    if (!_dataMuArr) {
        _dataMuArr = [NSMutableArray array];
        YCJMineInfoModel *infoModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_smrz" leftStr:ZCLocalizedString(@"实名认证", nil) rightStr:ZCLocalizedString(@"未认证", nil)];
        infoModel.actionBlock = ^(YCJMineInfoModel *info){
            if ([[YCJUserInfoManager sharedInstance].userInfoModel.authStatus intValue] == 1) {
                return;
            }
            YCJRealNameAlertView *alert = [[YCJRealNameAlertView alloc] init];
            alert.commonAlertViewDoneClickBlock = ^{
                [self loadUserInfo];
            };
            [alert show:self];
        };
        YCJMineInfoModel *focusModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_youxijilu" leftStr:ZCLocalizedString(@"游戏记录", nil) rightStr:@"" destinationClass:[YCJGameRecordViewController class]];
        YCJMineInfoModel *collectModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_zhua" leftStr:ZCLocalizedString(@"抓取记录", nil) rightStr:@"" destinationClass:[YCJFetchRecordViewController class]];
        YCJMineInfoModel *messageModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_shensu" leftStr:ZCLocalizedString(@"我的申诉", nil) rightStr:@"" destinationClass:[YCJComplaintRecordViewController class]];
        YCJMineInfoModel *moneyModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_xf" leftStr:ZCLocalizedString(@"消费记录", nil) rightStr:@"" destinationClass:[YCJConsumeViewController class]];
        YCJMineInfoModel *inviteModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_fenx" leftStr:ZCLocalizedString(@"邀请分享", nil) rightStr:@""];
        inviteModel.actionBlock = ^(YCJMineInfoModel *info) {
            [JKNetWorkManager getRequestWithUrlPath:JKInviteCodeInfoUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
                if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
                    YCJInviteCodeModel *inviteModel = [YCJInviteCodeModel mj_objectWithKeyValues:result.resultData];
                    YCJInvitationCodeAlertView *alert = [[YCJInvitationCodeAlertView alloc] init];
                    alert.inviteModel = inviteModel;
                    [alert show];
                }
            }];
        };
        YCJMineInfoModel *settingModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_mine_sz" leftStr:ZCLocalizedString(@"设置", nil) rightStr:@"" destinationClass:[YCJSettingViewController class]];
        [_dataMuArr addObject:infoModel];
        [_dataMuArr addObject:focusModel];
        [_dataMuArr addObject:collectModel];
        [_dataMuArr addObject:messageModel];
        [_dataMuArr addObject:moneyModel];
        [_dataMuArr addObject:inviteModel];
        [_dataMuArr addObject:settingModel];
    }
    return _dataMuArr;
}
@end
