

#import "YCJHomeViewController.h"
#import "QATabBarController.h"
#import "YCJHomeBannerCell.h"
#import "YCJPlayLasterItemCell.h"
#import "YCJHomePlayPostItemCell.h"
#import "YCJPosterDetailController.h"
#import "YCJSignInListModel.h"
#import "YCJHomeSigninAlertView.h"
#import "SKLoginViewController.h"
#import "KMNewPlayerViewController.h"
#import "QAConversionCentreViewController.h"
#import "YCJRankViewController.h"

@interface YCJHomeViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *otherView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *lastestArr;
@property (nonatomic,strong) NSArray *hotArr;
@property (nonatomic,strong) NSArray *bannerArr;

@end

@implementation YCJHomeViewController

- (NSArray *)titles {
    return @[ZCLocalizedString(@"推荐", nil), ZCLocalizedString(@"小游戏", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestLasterRoomList];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headView.hidden = NO;
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headView.hidden = YES;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self bgImageName:@"icon_mine_bg"];
    self.view.backgroundColor = kCommonWhiteColor;
    [self configUI];
    
    [self requestBannerList];
    [self requestGameProfileList];
}

- (void)requestBannerList {
    [JKNetWorkManager getRequestWithUrlPath:JKHomeBannerListUrlKey parameters:@{@"position":@"1"} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            self.bannerArr = result.resultData;
            
            [self requestGameProfileList];
        }
    }];
}
//
- (void)requestGameProfileList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameProfileListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            NSDictionary *dataDic = result.resultData;
            self.hotArr = dataDic[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - loadData
- (void)requestLasterRoomList {
    [JKNetWorkManager getRequestWithUrlPath:JKLastestGameRoomListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            self.lastestArr = result.resultData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)configUI {
    
    UIView *headView = [[UIView alloc] init];
    [self.navigationController.navigationBar addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.navigationController.navigationBar);
    }];
    self.headView = headView;
    CGFloat width = kSize(120);   
    UIView *itemView = [[UIView alloc] init];
    [headView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headView);
    }];
    CGFloat itemW = width/2.0;
    for (int i = 0; i < self.titles.count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        [itemView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemW);
            make.leading.mas_equalTo(itemView).offset(itemW*i);
            make.top.bottom.mas_equalTo(itemView);
        }];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:kColorHex(0xffffff) forState:UIControlStateSelected];
        [btn setTitleColor:kColorHex(0xd8d8d8) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = kPingFangRegularFont(16);
        btn.tag = i;
        if(i == 0) {
            self.lineView = [[UIView alloc] init];
            self.lineView.backgroundColor =  kColorHex(0xffffff);
            [itemView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn);
                make.bottom.mas_equalTo(itemView.mas_bottom).inset(8);
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(3);
            }];
            self.lineView.layer.cornerRadius = 1.5;
            btn.titleLabel.font = kPingFangSemiboldFont(16);
            btn.selected = YES;
            self.selectBtn = btn;
        }
    }
   
//    [self setupHeadViewSubviews:headView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(5+kStatusBarPlusNaviBarHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(kTabBarHeight);
    }];
}
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if([eventName isEqualToString:@"sign"]) {
        [self showSignInAlertView];
    } else if ([eventName isEqualToString:@"rank"]) {
        YCJRankViewController *rankVc = [[YCJRankViewController alloc] init];
        [self.navigationController pushViewController:rankVc animated:YES];
    } else if ([eventName isEqualToString:@"new"]) {
        KMNewPlayerViewController *vc = [[KMNewPlayerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([eventName isEqualToString:@"rechange"]) {
        QAConversionCentreViewController *convertVc = [[QAConversionCentreViewController alloc] init];
        [self.navigationController pushViewController:convertVc animated:YES];
    } else if ([eventName isEqualToString:@"service"]) {
        if ([[SKUserInfoManager sharedInstance] isLogin:self]) {
            QABaseWebViewController *web = [[QABaseWebViewController alloc] init];
            YCJToken *userToken = [SKUserInfoManager sharedInstance].userTokenModel;
            web.url = [NSString stringWithFormat:@"%@source=2&token=%@",kCustomerServiceBaseUrl,userToken.accessToken];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

- (void)showSignInAlertView {
    if ([[SKUserInfoManager sharedInstance] isLogin:self]) {
        [JKNetWorkManager getRequestWithUrlPath:JKSigninListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
            if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
                YCJSignInListModel *signModel = [YCJSignInListModel mj_objectWithKeyValues:result.resultData];
                YCJHomeSigninAlertView *sign = [[YCJHomeSigninAlertView alloc] init];
                [sign setListModel:signModel];
                [sign show];
                WeakSelf;
                sign.jumpLoginBlock = ^{
                    SKLoginViewController *vc = [[SKLoginViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                };
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else if (section == 1) {
        return self.lastestArr.count > 0?1:0;
    } else {
        return self.hotArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        YCJHomeBannerCell *cell = [YCJHomeBannerCell homeBannerCellWithTableView:tableView indexPath:indexPath];
        cell.dataArr = self.bannerArr;
        return cell;
    } else if (indexPath.section == 2) {
        YCJHomePlayPostItemCell *cell = [YCJHomePlayPostItemCell HomePlayPostItemCellWithTableView:tableView indexPath:indexPath];
        cell.dataDic = self.hotArr[indexPath.row];
        return cell;
    } else {
        YCJPlayLasterItemCell *cell = [YCJPlayLasterItemCell playLasterItemCellWithTableView:tableView indexPath:indexPath];
        cell.dataArr = self.lastestArr;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2) {
        NSDictionary *dataDic = self.hotArr[indexPath.row];
        YCJPosterDetailController *detailVc = [[YCJPosterDetailController alloc] init];
        detailVc.gameInfoId = kSafeContentString(dataDic[@"id"]);
        detailVc.title = kSafeContentString(dataDic[@"groupName"]);
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)setupHeadViewSubviews:(UIView *)headView {
    UILabel *titleL = [headView createSimpleLabelWithTitle:ZCLocalizedString(@"元宇宙游戏", nil) font:14 bold:NO color:kCommonWhiteColor];
    [headView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.leading.mas_equalTo(headView.mas_leading).offset(12);
    }];
    
    UIButton *msg = [[UIButton alloc] init];
    [headView addSubview:msg];
    [msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.trailing.mas_equalTo(headView.mas_trailing).inset(5);
        make.width.height.mas_equalTo(30);
    }];
    [msg setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    UIView *searchView = [[UIView alloc] init];
    [headView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleL.mas_trailing).offset(10);
        make.centerY.mas_equalTo(headView.mas_centerY);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(msg.mas_leading).inset(5);
    }];
    searchView.backgroundColor = rgba(255, 255, 255, 0.15);
    [searchView setViewCornerRadiu:8];
    [searchView setViewBorderWithColor:0.3 color:rgba(255, 255, 255, 1)];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [searchView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.leading.mas_equalTo(searchView.mas_leading).offset(7);
        make.width.height.mas_equalTo(16);
    }];
    
    UITextField *tf = [headView createTextFieldOnTargetView:headView withFrame:CGRectZero withPlaceholder:ZCLocalizedString(@"输入搜索内容", nil)];
    [searchView addSubview:tf];
    tf.font = kPingFangLightFont(14);
    tf.returnKeyType = UIReturnKeySearch;
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(7);
        make.top.bottom.mas_equalTo(searchView);
        make.width.mas_equalTo(200);
    }];
    tf.tintColor = kCommonWhiteColor;
    tf.delegate = self;
    
}

- (void)btnTypeClick:(UIButton *)sender {
    if(self.selectBtn == sender) return;
    QATabBarController *tabbar = (QATabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = sender.tag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *content = textField.text;
    if(content.length == 0) {
        return NO;
    }
    NSLog(@"come here");
    return YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YCJHomeBannerCell class] forCellReuseIdentifier:@"YCJHomeBannerCell"];
        [_tableView registerClass:[YCJPlayLasterItemCell class] forCellReuseIdentifier:@"YCJPlayLasterItemCell"];
        [_tableView registerClass:[YCJHomePlayPostItemCell class] forCellReuseIdentifier:@"YCJHomePlayPostItemCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0;
        } else {
            // Fallback on earlier versions
        }
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

@end
