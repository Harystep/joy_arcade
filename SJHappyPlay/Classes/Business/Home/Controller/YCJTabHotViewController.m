//
//  YCJTabHotViewController.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJTabHotViewController.h"
#import "QATabBarController.h"
#import "YCJPlayLasterItemCell.h"
#import "YCJPlayerHotItemCell.h"
#import "YCJGameRoomModel.h"
#import "KMGameRoomViewController.h"

@interface YCJTabHotViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *otherView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *roomCategoryList;
@property (nonatomic,strong) NSArray *lastestArr;

@end

@implementation YCJTabHotViewController

- (NSArray *)titles {
    return @[ZCLocalizedString(@"推荐", nil), ZCLocalizedString(@"小游戏", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headView.hidden = NO;
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestRoomList];
        [self requestLasterRoomList];
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
    [self configUI];
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
        } else {
            self.otherView = [[UIView alloc] init];
            self.otherView.backgroundColor =  kColorHex(0xffffff);
            [itemView addSubview:self.otherView];
            [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn);
                make.bottom.mas_equalTo(itemView.mas_bottom).inset(8);
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(3);
            }];
            self.otherView.layer.cornerRadius = 1.5;
            self.otherView.hidden = NO;
            btn.selected = YES;
            btn.titleLabel.font = kPingFangSemiboldFont(16);
            self.selectBtn = btn;
        }
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(5);
        make.top.mas_equalTo(self.view.mas_top).offset(5+kStatusBarPlusNaviBarHeight);
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

#pragma mark - loadData
- (void)requestRoomList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameRoomCategoryUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.roomCategoryList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        } else {
            NSArray *itemArr = [YCJGameRoomModel mj_objectArrayWithKeyValuesArray:result.resultData];
            NSMutableArray *temArr = [NSMutableArray array];
            for (YCJGameRoomModel *model in itemArr) {
                for (YCJGameRoomGroup *group in model.roomGroupList) {
                    group.name = model.name;
                    group.thumb = model.thumb;
                    [temArr addObject:group];
                }
            }
            self.roomCategoryList = temArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.lastestArr.count > 0?1:0;
    } else {
        return self.roomCategoryList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YCJPlayLasterItemCell *cell = [YCJPlayLasterItemCell playLasterItemCellWithTableView:tableView indexPath:indexPath];
        cell.dataArr = self.lastestArr;
        return cell;
    } else {
        YCJPlayerHotItemCell *cell = [YCJPlayerHotItemCell playerHotItemCellWithTableView:tableView indexPath:indexPath];
        cell.roomModel = self.roomCategoryList[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {        
        YCJGameRoomGroup *group = self.roomCategoryList[indexPath.row];
        KMGameRoomViewController *vc = [[KMGameRoomViewController alloc] init];
        vc.titleStr = group.name;
        vc.roomGroup = group;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0.01;
    } else {
        return 50.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return [UIView new];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *lbL = [self.view createSimpleLabelWithTitle:ZCLocalizedString(@"大家热玩", nil) font:20 bold:YES color:kCommonWhiteColor];
        [view addSubview:lbL];
        [lbL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY).offset(3);
            make.leading.mas_equalTo(view.mas_leading).offset(12);
        }];
        return view;
    }
}


- (void)btnTypeClick:(UIButton *)sender {
    if(self.selectBtn == sender) return;  
    QATabBarController *tabbar = (QATabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = sender.tag;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YCJPlayLasterItemCell class] forCellReuseIdentifier:@"YCJPlayLasterItemCell"];
        [_tableView registerClass:[YCJPlayerHotItemCell class] forCellReuseIdentifier:@"YCJPlayerHotItemCell"];
        _tableView.showsVerticalScrollIndicator = NO;
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
