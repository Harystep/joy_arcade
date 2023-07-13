

#import "YCJShopViewController.h"
#import "SKUserCoinView.h"
#import "KMVIPProcessView.h"
#import "YCJShopSwitchView.h"
#import "YCJShopZuansCell.h"
#import "YCJShopJinbCell.h"
#import "YCJShopModel.h"
#import "SJHappyPlay-Swift.h"
#import "YCJInAppPurchase.h"
#import "PPApplePayModule.h"
#import "SJRequestAppleCreateOrderModel.h"
#import "SJResponseAppleCreateOrderModel.h"
#import "PPChargeOtherPayResponseModel.h"
#import "SJPCChargeRequestModel.h"
#import "PPUserInfoService.h"
#import "SDRechargeWebViewController.h"
#import <WebKit/WebKit.h>
#import "YCJShopModel.h"

@interface YCJShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WKNavigationDelegate>
@property (nonatomic, strong) SKUserCoinView       *userCoinView;
@property (nonatomic, strong) KMVIPProcessView     *processView;
@property (nonatomic, strong) UIImageView           *growupBgView;
@property (nonatomic, strong) UILabel               *growupLB;
@property (nonatomic, strong) YCJShopSwitchView     *switchView;
@property (nonatomic, strong) UICollectionView      *collectionView;/* 容器视图 */
@property (nonatomic, assign) BOOL                  jinbi;
@property (nonatomic, strong) NSMutableArray        *jinBiList;
@property (nonatomic, strong) NSMutableArray        *zuanShiList;
@property (nonatomic, strong) YCJInAppPurchase      *iapHelp;
@property (nonatomic,strong) WKWebView *theWebView;
@property (nonatomic,strong) PPApplePayModule *applePayModule;
@property (nonatomic,strong) YCJShopModel *paySupport;

@end

@implementation YCJShopViewController

- (NSMutableArray *)jinBiList {
    if(!_jinBiList) {
        _jinBiList = [NSMutableArray array];
    }
    return _jinBiList;
}

- (NSMutableArray *)zuanShiList {
    if(!_zuanShiList) {
        _zuanShiList = [NSMutableArray array];
    }
    return _zuanShiList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"充值", nil);
    [self bgImageName:@"icon_mine_bg"];
    self.jinbi = YES;
    [self setSubviews];
    [self requestJinBiList];
    [self requestZuanShiList];
    [self reload];
    [self initPPGameSDK];
    self.applePayModule = [PPApplePayModule sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:YCJUserInfoModiyNotification object:nil];
}

- (void)reload {
    if ([SKUserInfoManager sharedInstance].userInfoModel) {
        self.growupBgView.hidden = NO;
        self.growupLB.text = [SKUserInfoManager sharedInstance].userInfoModel.memberLevelDto.tips;
    } else {
        self.growupBgView.hidden = YES;
        self.growupLB.text = @"";
    }
    
    self.growupBgView.hidden = YES;
}

- (void)networkChange:(BOOL)net {
    if (net && self.jinBiList.count == 0) {
        [self requestJinBiList];
        [self requestZuanShiList];
    }
    if (net) {
        [self removeEmptyView];
    } else {
        [self showError:ZCLocalizedString(@"网络异常，请稍后重试", nil)];
    }
}

- (void)requestJinBiList {
    /// type: int类型 1：钻石 2：金币
    [JKNetWorkManager getRequestWithUrlPath:JKChargeListUrlKey parameters:@{@"type": @2} finished:^(JKNetWorkResult * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
        if (result.error) {
            [self showError:ZCLocalizedString(@"网络异常，请稍后重试", nil)];
        }else {
            [self removeEmptyView];
            [self.jinBiList removeAllObjects];
            YCJShopModel *shopModel = [YCJShopModel mj_objectWithKeyValues:result.resultData];
            self.paySupport = shopModel;
            [self.jinBiList addObjectsFromArray:shopModel.optionList];
            [self.collectionView reloadData];
        }
    }];
}

- (void)requestZuanShiList {
    /// type: int类型 1：钻石 2：金币
    [JKNetWorkManager getRequestWithUrlPath:JKChargeListUrlKey parameters:@{@"type": @1} finished:^(JKNetWorkResult * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
        if (result.error) {
            [self showError:ZCLocalizedString(@"网络异常，请稍后重试", nil)];
        }else {
            [self removeEmptyView];
            [self.zuanShiList removeAllObjects];
            YCJShopModel *shopModel = [YCJShopModel mj_objectWithKeyValues:result.resultData];
            self.paySupport = shopModel;
            [self.zuanShiList addObjectsFromArray:shopModel.optionList];
            [self.collectionView reloadData];
        }
    }];
}


- (void)showError:(NSString *)errorText {
    WeakSelf
    [self setupEmptyViewWithText:errorText imageName:@"icon_net_error_a" isEmpty:YES action:^{
        StrongSelf
        [strongSelf requestJinBiList];
        [strongSelf requestZuanShiList];
    }];
    [self setEmptyViewTopOffset:230];
    [self setEmptyViewBgColor:[UIColor clearColor]];
    [self setEmptyContentViewBgColor:[UIColor clearColor]];
    [self setEmptyTextColor:kColorHex(0x7986B3)];
}

- (void)setSubviews {
    
    [self.view addSubview:self.userCoinView];
    [self.userCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + kSize(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.processView];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin + 30);
        make.top.equalTo(self.userCoinView.mas_bottom).offset(20);
        make.width.mas_equalTo(kSize(160));
        make.height.mas_equalTo(kSize(14));
    }];
    
    [self.view addSubview:self.growupBgView];
    [self.growupBgView addSubview:self.growupLB];
    [self.growupBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(30);
        make.centerY.equalTo(self.processView);
        make.height.mas_equalTo(30);
    }];
    
    [self.growupLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.growupBgView);
    }];
    
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.growupBgView.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
        make.top.equalTo(self.switchView.mas_bottom).offset(10);
    }];
    WeakSelf;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(weakSelf.jinbi) {
            [weakSelf requestJinBiList];
        } else {
            [weakSelf requestZuanShiList];
        }
    }];
    
}

- (void)buyWithModel:(YCJShopCellModel *)model {
    
    if ([[JKTools handelString:model.iosOption] isEqualToString:@""]){
        [MBProgressHUD showError:@"产品id无效"];
        return;
    }
    
    [[IAPHelper shared] startApplePayWithProduct:model.iosOption goodId:model.goodsID type:model.buyType];
    [IAPHelper shared].paymentCancelledCallBack = ^(NSString *errMsg){
        NSLog(@"errMsg:%@", errMsg);
        kRunAfter(0.3, ^{
            if (errMsg.length <= 0) {
                [MBProgressHUD showError:ZCLocalizedString(@"取消购买", nil)];
            } else {
                [MBProgressHUD showError:errMsg];
            }
        });
    };
    [IAPHelper shared].paymentSuccessfulCallBack = ^{
        NSLog(@"产品购买成功咯");
        kRunAfter(0.3, ^{
            [MBProgressHUD showError:ZCLocalizedString(@"购买成功", nil)];
        });
        /// 购买成功，刷新用户信息
        [[SKUserInfoManager sharedInstance] reloadUserInfo];
    };
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
    if (self.jinbi) {
        return self.jinBiList.count;
    } else {
        return self.zuanShiList.count;
    }
}
/* 设置方块的视图 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.jinbi) {
        //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
        YCJShopJinbCell *cell =
                [YCJShopJinbCell cellWithCollectionView:collectionView
                                                forIndexPath:indexPath];
        cell.goodModel = self.jinBiList[indexPath.item];
        return cell;
    } else {
        //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
        YCJShopZuansCell *cell =
                [YCJShopZuansCell cellWithCollectionView:collectionView
                                                forIndexPath:indexPath];
        cell.goodModel = self.zuanShiList[indexPath.item];
        return cell;
    }
}


#pragma mark - UICollectionViewDelegate
/* 方块被选中会调用 */
- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击选择了第%ld组第%ld个方块",indexPath.section,indexPath.row);
    YCJShopCellModel *model;
    if (self.jinbi) {
        model = self.jinBiList[indexPath.item];
    } else {
        model = self.zuanShiList[indexPath.item];
    }
    if ([[SKUserInfoManager sharedInstance] isLogin:self]) {
//        [self buyWithModel:model];
        NSInteger payType = [self convertPayTypeWithData:self.paySupport];
        if(payType == 3) {
            [self chargeByApple:model];
        } else {
            [self chargeByAli:model];
        }
    }
}

- (NSInteger)convertPayTypeWithData:(YCJShopModel *)option {
    NSInteger type = 3;
    for (YCJPaySupport *model in option.paySupport) {
        if([model.payMode integerValue] == 3) {//
            type = 3;
            break;
        } else {
            type = 2;
        }
    }
    return type;
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

- (void)chargeByAli:(YCJShopCellModel *)data {
    [self showLoading];
    SJPCChargeRequestModel *requestModel = [[SJPCChargeRequestModel alloc] init];
//    requestModel.type = 2;
    if([data.mark isEqualToString:@"周卡"] || [data.mark isEqualToString:@"月卡"]) {
        requestModel.b_id = [NSString stringWithFormat:@"card:%@", data.goodsID];
    } else {
        requestModel.b_id = [NSString stringWithFormat:@"option:%@", data.goodsID];
    }
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    WeakSelf;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        [weakSelf hideLoading];
        if (!error) {
            PPChargeOtherPayResponseModel * otherPayResponseModel = (PPChargeOtherPayResponseModel *)responseModel;
            [weakSelf showChargeAliPayWebView:otherPayResponseModel.data];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView makeToast:error.message];
            });
        }
    }];
}

- (void)chargeByApple:(YCJShopCellModel *)data {
    [self showLoading];
    SJRequestAppleCreateOrderModel *requestModel = [[SJRequestAppleCreateOrderModel alloc] init];
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    if([data.mark isEqualToString:@"周卡"] || [data.mark isEqualToString:@"月卡"]) {
        requestModel.productId = [NSString stringWithFormat:@"card:%@", data.goodsID];
    } else {
        requestModel.productId = [NSString stringWithFormat:@"option:%@", data.goodsID];
    }
    WeakSelf;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if(!error) {
            SJResponseAppleCreateOrderModel *model = (SJResponseAppleCreateOrderModel *)responseModel;
            [self.applePayModule pay:data.iosOption withOrderId:data.goodsID orderSn:model.data.orderSn withBlock:^(NSString * _Nonnull receipt) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [self.view makeToast:ZCLocalizedString(@"购买成功", nil)];
                    /// 购买成功，刷新用户信息
                    [[SKUserInfoManager sharedInstance] reloadUserInfo];
                });
            } withFaileBlock:^(NSString * _Nonnull errMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [self.view makeToast:errMessage];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoading];
                [self.view makeToast:error.message];
            });
        }
    }];
}

- (void)showChargeAliPayWebView:(NSString *)data {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [self.theWebView loadHTMLString:data baseURL: nil];
    } else {
        SDRechargeWebViewController * webViewController = [[SDRechargeWebViewController alloc] initWithData:data];
        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:webViewController animated:true completion:nil];
    }
}

#pragma mark - WKNavigationDelegate
- (void)                  webView:(WKWebView *)webView
  decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                  decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSString * url = (request.URL).absoluteString;
    if ([url hasPrefix:@"alipay://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {
            if (!success) {
                [self.view makeToast:ZCLocalizedString(@"支付失败", nil)];
            } else {
                [self.view makeToast:ZCLocalizedString(@"购买成功", nil)];
                /// 购买成功，刷新用户信息
                [[SKUserInfoManager sharedInstance] reloadUserInfo];
            }
        }];
        [self onDissmissContentView];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)onDissmissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.theWebView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.theWebView removeFromSuperview];
    }];
    
}

- (WKWebView *)theWebView{
  if (!_theWebView) {
    WKWebView * theView = [[WKWebView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.trailing.trailing.equalTo(self);
        make.edges.mas_equalTo(self);
    }];
      theView.hidden = true;
    theView.navigationDelegate = self;
    _theWebView = theView;
  }
  return _theWebView;
}

- (void)showLoading {
  [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
    });
}

- (void)initPPGameSDK {    
    /// 需要更换请求地址
    [PPNetworkConfig sharedInstance].base_request_url = kPPGameBaseRequestUrl;
    /// 更换 tcp请求的地址
    [PPNetworkConfig sharedInstance].base_my_host = kPPGameBaseMyHost;
    /// 更换 tcp 请求的 port
    [PPNetworkConfig sharedInstance].base_my_port = kPPGameBaseMyPort.integerValue;
    //添加渠道参数
    [PPNetworkConfig sharedInstance].channelKey = kPPGameChannelKey;
    
    
    YCJToken *userToken = [SKUserInfoManager sharedInstance].userTokenModel;
    if(userToken.accessToken.length > 0) {
        [[PPUserInfoService get_Instance] setAccess_token:userToken.accessToken];
    }
               
}

#pragma mark -- lazy
- (SKUserCoinView *)userCoinView {
    if (!_userCoinView) {
        _userCoinView = [[SKUserCoinView alloc] init];
    }
    return _userCoinView;
}

- (KMVIPProcessView *)processView {
    if (!_processView) {
        _processView = [[KMVIPProcessView alloc] initWithFrame:CGRectMake(0, 0, kSize(160), kSize(14))];
    }
    return _processView;
}

- (UIImageView *)growupBgView {
    if (!_growupBgView) {
        _growupBgView = [[UIImageView alloc] init];
        _growupBgView.contentMode = UIViewContentModeScaleAspectFit;
        _growupBgView.image = [UIImage imageNamed:@"icon_shop_grow_bg"];
        _growupBgView.hidden = YES;
    }
    return _growupBgView;
}

- (UILabel *)growupLB {
    if (!_growupLB) {
        _growupLB = [[UILabel alloc] init];
        _growupLB.text = @"再充值88元即可升级V1";
        _growupLB.textAlignment = NSTextAlignmentCenter;
        _growupLB.font = kPingFangMediumFont(12);
        _growupLB.textColor = kCommonWhiteColor;
        _growupLB.hidden = YES;
    }
    return _growupLB;
}

- (YCJShopSwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[YCJShopSwitchView alloc] init];
        WeakSelf
        _switchView.switchClickBlock = ^(NSInteger tag) {
            StrongSelf
            strongSelf.jinbi = (tag == 2);
            [strongSelf.collectionView reloadData];
        };
    }
    return _switchView;
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
        [_collectionView registerClass:[YCJShopJinbCell class]
            forCellWithReuseIdentifier:[YCJShopJinbCell cellIdentifier]];
        [_collectionView registerClass:[YCJShopZuansCell class]
                forCellWithReuseIdentifier:[YCJShopZuansCell cellIdentifier]];
        _collectionView.layer.masksToBounds = YES;
    }
    return _collectionView;
}



@end
