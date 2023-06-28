//
//  YCJSettingViewController.m
//  YCJieJiGame
//
//  Created by zza on 2023/5/22.
//

#import "YCJSettingViewController.h"
#import "YCJSettingCell.h"
#import "YCJMineInfoModel.h"
#import "YCJAccountLogoutAlertView.h"
#import "YCJTabBarController.h"

@interface YCJSettingViewController ()
<UITableViewDataSource,
UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <YCJMineInfoModel *> *dataMuArr;

@end

@implementation YCJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"设置", nil);
    [self bgImageWhite];
    [self configUI];
}

- (void)configUI {
    
    UIView *lanView = [[UIView alloc] init];
    [self.view addSubview:lanView];
    [lanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(kMargin);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + 15);
    }];
    lanView.backgroundColor = kCommonWhiteColor;
    lanView.cornerRadius = kSize(8);
    
    [self setupLanViewSubviews:lanView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.top.mas_equalTo(lanView.mas_bottom).offset(kMargin);
        make.height.mas_offset(40 + kSize(44) * self.dataMuArr.count);
    }];
}

- (void)setupLanViewSubviews:(UIView *)lanView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_setting_yonghuxieyi"]];
    [lanView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lanView.mas_centerY);
        make.leading.mas_equalTo(lanView.mas_leading).offset(kMargin);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kPingFangMediumFont(15);
    titleL.textColor = kCommonBlackColor;
    titleL.textAlignment = NSTextAlignmentLeft;
    [lanView addSubview:titleL];
    titleL.text = ZCLocalizedString(@"语言", nil);
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lanView.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(kSize(8));
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"icon_mine_arrowR"];
    [lanView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lanView.mas_centerY);
        make.trailing.mas_equalTo(lanView.mas_trailing).inset(kMargin);
    }];
    
    UILabel *subL = [[UILabel alloc] init];
    subL.font = kPingFangMediumFont(14);
    subL.textColor = kShallowBlackColor;
    subL.textAlignment = NSTextAlignmentLeft;
    [lanView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lanView.mas_centerY);
        make.trailing.mas_equalTo(arrowImageView.mas_leading).inset(kSize(8));
    }];
    if([SJLocalTool getCurrentLanguage] == 3) {
        subL.text = @"English";
    } else if ([SJLocalTool getCurrentLanguage] == 2) {
        subL.text = @"繁体中文";
    } else {
        subL.text = @"简体中文";
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setLanguageOp)];
    [lanView addGestureRecognizer:tap];
    
}

- (void)setLanguageOp {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:ZCLocalizedString(@"语言设置", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf;
    UIAlertAction *lan = [UIAlertAction actionWithTitle:ZCLocalizedString(@"简体中文", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SJLocalTool saveUserLanguageType:1];
        [weakSelf turnWithDuration:1.25 completion:^{
        }];
    }];
    UIAlertAction *hant = [UIAlertAction actionWithTitle:ZCLocalizedString(@"繁体中文", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SJLocalTool saveUserLanguageType:2];
        [weakSelf turnWithDuration:1.25 completion:^{
        }];
    }];
    UIAlertAction *en = [UIAlertAction actionWithTitle:ZCLocalizedString(@"英文", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SJLocalTool saveUserLanguageType:3];
        [weakSelf turnWithDuration:1.25 completion:^{
        }];
    }];
    
    UIAlertAction *cn = [UIAlertAction actionWithTitle:ZCLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alertVc addAction:lan];
    [alertVc addAction:hant];
    [alertVc addAction:en];
    [alertVc addAction:cn];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMuArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCJSettingCell *cell = [YCJSettingCell cellWithTableView:tableView];
    cell.settingInfoModel = [self.dataMuArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCJMineInfoModel *info = [self.dataMuArr objectAtIndex:indexPath.row];
    if(info.destinationClass) {
        [self.navigationController pushViewController:[info.destinationClass new] animated:YES];
    }else if(info.actionBlock) {
        info.actionBlock(info);
    }
}

#pragma mark —— lazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, -20);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = kSize(44);
        _tableView.scrollEnabled = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.cornerRadius = kSize(8);
    }
    return _tableView;
}

- (NSMutableArray<YCJMineInfoModel *> *)dataMuArr{
    if (!_dataMuArr) {
        _dataMuArr = [NSMutableArray array];
        YCJMineInfoModel *userModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_setting_yonghuxieyi" leftStr:ZCLocalizedString(@"用户协议", nil) rightStr:@""];
        userModel.actionBlock = ^(YCJMineInfoModel *info){
            YCJBaseWebViewController *web = [[YCJBaseWebViewController alloc] init];
            web.url = JKUserAgreementUrlKey;
            web.navigationItem.title = ZCLocalizedString(@"用户协议", nil);
            [self.navigationController pushViewController:web animated:YES];
        };
        YCJMineInfoModel *privateModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_setting_yinsizhengce" leftStr:ZCLocalizedString(@"隐私政策", nil) rightStr:@""];
        privateModel.actionBlock = ^(YCJMineInfoModel *info) {
            YCJBaseWebViewController *web = [[YCJBaseWebViewController alloc] init];
            web.url = JKPrivacyPolicyUrlKey;
            web.navigationItem.title = ZCLocalizedString(@"隐私政策", nil);
            [self.navigationController pushViewController:web animated:YES];
        };
        
        YCJMineInfoModel *cancellationModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_setting_cancellation" leftStr:ZCLocalizedString(@"注销账号", nil) rightStr:@""];
        cancellationModel.actionBlock = ^(YCJMineInfoModel *info) {
            YCJAccountLogoutAlertView *canAlert = [[YCJAccountLogoutAlertView alloc] init];
            canAlert.type = YCJAccountTypeCancellation;
            canAlert.commonAlertViewDoneClickBlock = ^{
                [JKNetWorkManager postRequestWithUrlPath:JKAccountCancelUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
                    if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
                        [MBProgressHUD showSuccess:ZCLocalizedString(@"注销成功", nil)];
                        self.tabBarController.selectedIndex = 2;
                        [[YCJUserInfoManager sharedInstance] deleteUserInfo];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            };
            [canAlert show];
        };
        
        YCJMineInfoModel *logoutModel = [YCJMineInfoModel modelWithLeftIcon:@"icon_setting_tuichu" leftStr:ZCLocalizedString(@"退出登录", nil) rightStr:@""];
        logoutModel.actionBlock = ^(YCJMineInfoModel * _Nonnull info) {
            YCJAccountLogoutAlertView *canAlert = [[YCJAccountLogoutAlertView alloc] init];
            canAlert.type = YCJAccountTypeLogout;
            canAlert.commonAlertViewDoneClickBlock = ^{
                self.tabBarController.selectedIndex = 2;
                /// 删除用户Token信息
                [[YCJUserInfoManager sharedInstance] deleteUserInfo];
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [canAlert show];
        };
        
        [_dataMuArr addObject:userModel];
        [_dataMuArr addObject:privateModel];
        [_dataMuArr addObject:cancellationModel];
        [_dataMuArr addObject:logoutModel];
    }
    return _dataMuArr;
}
 
/**
 翻转
 
 @param duration 翻转动画所需时间
 @param completion 动画结束后的回调
 */
- (void)turnWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion{   
    // 翻转180度
    self.navigationController.navigationBar.hidden = YES;
    [UIView animateWithDuration:duration animations:^{
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        self.view.layer.transform = transform;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = [[YCJTabBarController alloc] init];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }];
    
}

@end
