//
//  YCJConversionCentreViewController.m
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJConversionCentreViewController.h"
#import "YCJUserCoinView.h"
#import "YCJInputItemView.h"
#import "YCJExchangeCoinsAlertView.h"
#import "YCJExchangeSuccessAlertView.h"
#import "YCJExchangeCell.h"
#import "GradientButton.h"
#import "YCJExchangeModel.h"

@interface YCJConversionCentreViewController ()<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) YCJUserCoinView      *userView;
@property (nonatomic, strong) UIView               *exchangeView;
@property (nonatomic, strong) UITextField          *exchangeTF;
@property (nonatomic, strong) GradientButton       *sureBtn;
@property (strong, nonatomic) UICollectionView     *collectionView;/* 容器视图 */
@property (nonatomic, strong) NSMutableArray        *exchangeList;
@end

@implementation YCJConversionCentreViewController

- (NSMutableArray *)exchangeList {
    if(!_exchangeList) {
        _exchangeList = [NSMutableArray array];
    }
    return _exchangeList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"兑换中心", nil);
    [self bgImageName:@"icon_mine_bg"];
    
    [self setSubviews];
    [self requestExchangeList];
}

- (void)networkChange:(BOOL)net {
    if (net && self.exchangeList.count == 0) {
        [self requestExchangeList];
    }
    if (net) {
        [self removeEmptyView];
    } else {
        [self showError:@"网络异常，请稍后重试"];
    }
}

- (void)requestExchangeList {
    [JKNetWorkManager getRequestWithUrlPath:JKJifen2JBListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [self showError:@"网络异常，请稍后重试"];
        }else {
            [self removeEmptyView];
            self.exchangeList = [YCJExchangeModel mj_objectArrayWithKeyValuesArray:result.resultData[@"list"]];
            [self.collectionView reloadData];
        }
    }];
}

- (void)showError:(NSString *)errorText {
    WeakSelf
    [self setupEmptyViewWithText:errorText imageName:@"icon_net_error_a" isEmpty:YES action:^{
        StrongSelf
        [strongSelf requestExchangeList];
    }];
    [self setEmptyViewTopOffset:250];
    [self setEmptyViewBgColor:[UIColor clearColor]];
    [self setEmptyContentViewBgColor:[UIColor clearColor]];
    [self setEmptyTextColor:kColorHex(0x7986B3)];
}

- (void)setSubviews {
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + kSize(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.exchangeView];
    [self.exchangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(kSize(5));
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(kSize(150));
    }];
    
    [self.exchangeView addSubview:self.exchangeTF];
    [self.exchangeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.exchangeView);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.exchangeView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.exchangeView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(130);
        make.right.mas_equalTo(-24);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
        make.top.equalTo(self.exchangeView.mas_bottom).offset(10);
    }];
}

- (void)sureBtnAction {
    if ([[YCJUserInfoManager sharedInstance] isLogin:self]) {
        [self.view endEditing:YES];
        if (self.exchangeTF.text.length <= 0) {
            [MBProgressHUD showError:@"请输入钻石数量"];
            return;
        }
        YCJExchangeCoinsAlertView *alert = [[YCJExchangeCoinsAlertView alloc] init];
        alert.commonAlertViewDoneClickBlock = ^(YCJExchangeCoinsAlertView *alt, YCJExchangeModel *model){
            WeakSelf
            [JKNetWorkManager postRequestWithUrlPath:JKZuanshi2JBUrlKey parameters:@{@"num": weakSelf.exchangeTF.text} finished:^(JKNetWorkResult * _Nonnull result) {
                [alt dismiss];
                weakSelf.exchangeTF.text = @"";
                if (result.error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:result.error.localizedDescription];
                }else {
                    YCJExchangeSuccessAlertView *succ = [[YCJExchangeSuccessAlertView alloc] init];
                    [succ show];
                    [[YCJUserInfoManager sharedInstance] reloadUserInfo];
                }
            }];
        };
        alert.zuanshi = self.exchangeTF.text;
        [alert show];
    }
}

#pragma mark - UICollectionViewDataSource
/* 设置容器中有多少个组 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/* 设置每个组有多少个方块 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.exchangeList.count;
}
/* 设置方块的视图 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
    YCJExchangeCell *cell =
            [YCJExchangeCell cellWithCollectionView:collectionView
                                            forIndexPath:indexPath];
    cell.exchangeModel = self.exchangeList[indexPath.item];
    return cell;
}


#pragma mark - UICollectionViewDelegate
/* 方块被选中会调用 */
- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[YCJUserInfoManager sharedInstance] isLogin:self]) {
        YCJExchangeCoinsAlertView *alert = [[YCJExchangeCoinsAlertView alloc] init];
        alert.commonAlertViewDoneClickBlock = ^(YCJExchangeCoinsAlertView *alt, YCJExchangeModel *model){
            [MBProgressHUD showLoadingMessage:@""];
            [JKNetWorkManager postRequestWithUrlPath:JKJifen2JBUrlKey parameters:@{@"optionId": model.exchangeId} finished:^(JKNetWorkResult * _Nonnull result) {
                [alt dismiss];
                if (result.error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:result.error.localizedDescription];
                }else {
                    YCJExchangeSuccessAlertView *succ = [[YCJExchangeSuccessAlertView alloc] init];
                    [succ show];
                    [[YCJUserInfoManager sharedInstance] reloadUserInfo];
                }
            }];
        };
        alert.exchangeModel = self.exchangeList[indexPath.item];
        [alert show];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
/* 设置各个方块的大小尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenWidth - 10 - 2 * kMargin) / 2;
    CGFloat height = 150;
    return CGSizeMake(width, height);
}
/* 设置每一组的上下左右间距 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kMargin, 0, kMargin);
}

#pragma mark -- lazy
- (YCJUserCoinView *)userView {
    if (!_userView) {
        _userView = [[YCJUserCoinView alloc] init];
    }
    return _userView;
}

- (UIView *)exchangeView {
    if (!_exchangeView) {
        _exchangeView = [[UIView alloc] init];
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_exchange_top_bg"]];
        bgImg.contentMode = UIViewContentModeScaleToFill;
        [_exchangeView addSubview:bgImg];
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_exchangeView);
        }];
        
        UILabel *remindLb = [[UILabel alloc] init];
        remindLb.text = @"1钻石可兑换10金币";
        remindLb.textAlignment = NSTextAlignmentCenter;
        remindLb.textColor = kColorHex(0x4E5B83);
        remindLb.font = kPingFangRegularFont(14);
        [_exchangeView addSubview:remindLb];
        [remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_exchangeView);
            make.top.equalTo(_exchangeView.mas_centerY).multipliedBy(1.5);
            make.height.mas_equalTo(30);
        }];
    }
    return _exchangeView;
}

- (UITextField *)exchangeTF {
    if (!_exchangeTF) {
        _exchangeTF = [YCJInputItemView createTextFieldWithPlaceHolder:@"请输入"];
        _exchangeTF.cornerRadius = 25;
        _exchangeTF.borderColor = kCommonWhiteColor;
        _exchangeTF.borderWidth = 1.5;
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 18, 1);
        _exchangeTF.leftView = left;
        _exchangeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _exchangeTF;
}

- (GradientButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[GradientButton alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        [_sureBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kColorHex(0x4F3E0B) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangMediumFont(16);
        _sureBtn.cornerRadius = 19;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建布局对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        _collectionView.delegate = self;//设置代理
        _collectionView.dataSource = self;//设置数据源
        _collectionView.backgroundColor = [UIColor clearColor];//设置背景，默认为黑色
        //注册容器视图中显示的方块视图
        [_collectionView registerClass:[YCJExchangeCell class]
                forCellWithReuseIdentifier:[YCJExchangeCell cellIdentifier]];
        //注册容器视图中显示的顶部视图
//        [_collectionView registerClass:[LTCollectionHeaderView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                  withReuseIdentifier:[LTCollectionHeaderView headerViewIdentifier]];
        //注册容器视图中显示的底部视图
//        [_collectionView registerClass:[LTCollectionFooterView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                  withReuseIdentifier:[LTCollectionFooterView footerViewIdentifier]];
    }
    return _collectionView;
}

@end
