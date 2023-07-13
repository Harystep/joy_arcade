

#import "SJRechargeVerAlertView.h"

#import "SJPCChargeListRequestModel.h"

#import "PPUserInfoService.h"

#import "SJPCChargeListResponseModel.h"

#import "Masonry.h"

#import "SDRechargeUnitDataModel.h"

#import "SDRechargeUnitCollectionViewCell.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "SDRechargeUnitCycleCollectionViewCell.h"
#import "PPApplePayModule.h"
#import "UIView+Toast.h"
#import "AppDefineHeader.h"

#import "PPChargeUnitModel.h"

#import "SJPCChargeRequestModel.h"

#import "PPChargeOtherPayResponseModel.h"

#import "MBProgressHUD.h"

#import <WebKit/WebKit.h>

#import "SJChargeCardRequestModel.h"

#import "PPApplePayModule.h"

#import "SDRechargeWebViewController.h"
#import "PPChargetCoinData.h"
#import "SJRechargeCoinCollectionViewCell.h"
#import "SJPCChargeCoinByAppleCheckRequestModel.h"
#import "SJRequestAppleCreateOrderModel.h"
#import "SJResponseAppleCreateOrderModel.h"

@interface SJRechargeVerAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, WKNavigationDelegate>

@property (nonatomic, weak) UIView *theChargetContentView;

@property (nonatomic, weak) UICollectionView * theCollectionView;

@property (nonatomic,strong) UIButton *theCloseButton;

@property (nonatomic,strong) UIImageView *theChargeBgImageView;

@property (nonnull, nonatomic, strong) NSMutableArray<PPChargetCoinData * >* dataList;

//@property (nonatomic, strong) NSMutableArray<SDRechargeUnitDataModel *> * weekDataList;

@property (nonatomic, strong) PPApplePayModule * applePayModule;
@property (nonatomic,strong) UILabel *theTitleLabel;
@property (nonatomic, weak) WKWebView * theWebView;

@end

@implementation SJRechargeVerAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.alpha = 1;
    [self configView];
    [self configData];
    
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)configData {
    
    self.applePayModule = [PPApplePayModule sharedInstance];
    
    self.dataList = [NSMutableArray array];
    SJPCChargeListRequestModel * requestModel = [[SJPCChargeListRequestModel alloc] init];
    requestModel.type = @"2";
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        SJPCChargeListResponseModel * result = (SJPCChargeListResponseModel *)responseModel;
        PCChargeTypeInfoModel * data = result.data;        
//        if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
//            if(data.month != nil) {
//                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:data.month];
//                coinModel.type = 100003;
//                coinModel.payType = [self convertPayTypeWithData:data.paySupport];
//                [self.dataList addObject:coinModel];
//            }
//            if(data.week != nil) {
//                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:data.week];
//                coinModel.type = 100002;
//                coinModel.payType = [self convertPayTypeWithData:data.paySupport];
//                [self.dataList addObject:coinModel];
//            }
//            if(data.first != nil) {
//                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:data.first];
//                coinModel.type = 100001;
//                coinModel.payType = [self convertPayTypeWithData:data.paySupport];
//                [self.dataList addObject:coinModel];
//            }
//        }
        [data.optionList enumerateObjectsUsingBlock:^(PPChargeUnitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger payType = [self convertPayTypeWithData:data.paySupport];
            if([obj.mark isEqualToString:@"月卡"]) {
                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:obj];
                coinModel.type = 100003;
                coinModel.payType = payType;
                [self.dataList addObject:coinModel];
            } else if([obj.mark isEqualToString:@"周卡"]) {
                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:obj];
                coinModel.type = 100002;
                coinModel.payType = payType;
                [self.dataList addObject:coinModel];
            } else if([obj.mark isEqualToString:@"首充"]) {
                PPChargetCoinData *coinModel = [[PPChargetCoinData alloc] initWithCoinData:obj];
                coinModel.type = 100001;
                coinModel.payType = payType;
                [self.dataList addObject:coinModel];
            } else {                
                PPChargetCoinData * itemData = [[PPChargetCoinData alloc] initWithCoinData:obj];
                itemData.payType = payType;
                [self.dataList addObject:itemData];
            }
        }];
        [self.theCollectionView reloadData];
    }];    
}

- (NSInteger)convertPayTypeWithData:(NSArray *)option {
    NSInteger type = 3;
    for (NSDictionary *dic in option) {
        if([dic[@"payMode"] integerValue] == 3) {//
            type = 3;
            break;
        } else {
            type = 2;
        }
    }
    return type;
}

- (void)configView {
    [self theWebView];
    [self theChargetContentView];
    [self theChargeBgImageView];
    [self theTitleLabel];
    [self coinDataView];
    [self theCloseButton];
}
#pragma mark - action
- (void)onCloseBarPress {
    [self onDissmissContentView];
}
- (void)showChargeAliPayData:(NSString*) payData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(showChargeAliPayViewData:)]) {
            [self.delegate showChargeAliPayViewData:payData];
        }
    });
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

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;  
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJRechargeCoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJRechargeCoinCollectionViewCell" forIndexPath:indexPath];
    PPChargetCoinData * data = self.dataList[indexPath.row];
    [cell loadCoinModel:data];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger section = indexPath.section;
//    if (section == 1) {
//        return CGSizeMake(DSize(330), DSize(260));
//    }
//    return CGSizeMake(DSize(330), DSize(220));
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, DSize(30), 0);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    PPChargetCoinData *model = self.dataList[indexPath.row];
    if (model.payType == 3) {
        [self chargeByApple:model.originData type:model.type];
    } else {
        [self chargeByAli:model];
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
                [self makeToast:ZCLocal(@"支付失败")];
            }
        }];
        [self onCloseBarPress];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)chargeByAli:(PPChargetCoinData *)coinData {
    [self showLoading];
    SJPCChargeRequestModel *requestModel = [[SJPCChargeRequestModel alloc] init];
    requestModel.type = 2;
    if(coinData.type == 100002 || coinData.type == 100003) {
        requestModel.b_id = [NSString stringWithFormat:@"card:%@", coinData.chargeId];
    } else {
        requestModel.b_id = [NSString stringWithFormat:@"option:%@", coinData.chargeId];
    }
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    @weakify_self;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        @strongify_self;
        [self hideLoading];
        if (!error) {
            PPChargeOtherPayResponseModel * otherPayResponseModel = (PPChargeOtherPayResponseModel *)responseModel;
            [self showChargeAliPayData:otherPayResponseModel.data];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self makeToast:error.message];
            });
        }
    }];
}

- (void)chargeByApple:(PPChargeUnitModel *)data type:(NSInteger)type {
    [self showLoading];
    SJRequestAppleCreateOrderModel *requestModel = [[SJRequestAppleCreateOrderModel alloc] init];
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    if(type == 100002 || type == 100003) {
        requestModel.productId = [NSString stringWithFormat:@"card:%@", data.chargeId];
    } else {
        requestModel.productId = [NSString stringWithFormat:@"option:%@", data.chargeId];
    }
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        @weakify_self;
        if(!error) {
            SJResponseAppleCreateOrderModel *model = (SJResponseAppleCreateOrderModel *)responseModel;
            [self.applePayModule pay:data.iosOption withOrderId:data.chargeId orderSn:model.data.orderSn withBlock:^(NSString * _Nonnull receipt) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [self makeToast:ZCLocal(@"支付成功")];
                    if([self.delegate respondsToSelector:@selector(paySuccessStatus)]) {
                        [self.delegate paySuccessStatus];
                    }
                });
            } withFaileBlock:^(NSString * _Nonnull errMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoading];
                    [self makeToast:errMessage];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoading];
                [self makeToast:error.message];
            });
        }        
    }];
}

- (void)checkApplePay:(PPChargeUnitModel * )data andAppleReceipt:(NSString *) receipt{
    SJPCChargeCoinByAppleCheckRequestModel *requestModel = [[SJPCChargeCoinByAppleCheckRequestModel alloc] init];
    requestModel.receipt = receipt;
    if(data.type == 100002 || data.type == 100003) {
        requestModel.productId = [NSString stringWithFormat:@"card:%@", data.chargeId];
    } else {
        requestModel.productId = [NSString stringWithFormat:@"option:%@", data.chargeId];
    }
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        [self hideLoading];
        if (!error) {
            [self.applePayModule finishTransactionForAp];
            if([self.delegate respondsToSelector:@selector(paySuccessStatus)]) {
                [self.delegate paySuccessStatus];
            }
        } else {
            [self makeToast:ZCLocal(@"支付失败")];
        }
    }];
}

- (void)onDissmissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if([self.delegate respondsToSelector:@selector(dissmissChargeController)]) {
        [self.delegate dissmissChargeController];
    }
}

- (void)showLoading {
  [MBProgressHUD showHUDAddedTo:self animated:true];
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:true];
    });
}

#pragma mark - lazy UI
- (UICollectionView *)theCollectionView{
    if (!_theCollectionView) {
        UICollectionViewFlowLayout * flowLayot = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.theChargetContentView).inset(12);
            make.bottom.mas_equalTo(self.theChargetContentView.mas_bottom).inset(5);
            make.top.mas_equalTo(self.coinDataView.mas_bottom).offset(10);
        }];
        flowLayot.itemSize = CGSizeMake(145, DSize(292));
        theView.dataSource = self;
        theView.delegate = self;
        theView.showsVerticalScrollIndicator = NO;
        theView.backgroundColor = UIColor.clearColor;
        theView.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
        [theView registerClass:[SJRechargeCoinCollectionViewCell class] forCellWithReuseIdentifier:@"SJRechargeCoinCollectionViewCell"];
        _theCollectionView = theView;
    }
    return _theCollectionView;
}
- (WKWebView *)theWebView{
  if (!_theWebView) {
    WKWebView * theView = [[WKWebView alloc] init];
    [self addSubview:theView];
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

- (SJUserRechargeCoinDataView *)coinDataView {
    if (!_coinDataView) {
        _coinDataView = [[SJUserRechargeCoinDataView alloc] init];
        [self.theChargetContentView addSubview:_coinDataView];
        [_coinDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.theChargetContentView.mas_centerX);
            make.top.mas_equalTo(self.theChargetContentView.mas_top).offset(DSize(118));
            make.width.mas_equalTo(DSize(520));
        }];
    }
    return _coinDataView;
}

- (UILabel *)theTitleLabel {
    if (!_theTitleLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theChargetContentView);
            make.top.equalTo(self.theChargetContentView).offset(SF_Float(44));
        }];
        theView.textColor = [UIColor whiteColor];
        theView.font = AutoBoldPxFont(36);
        theView.text = ZCLocal(@"充值中心");
        _theTitleLabel = theView;
    }
    return _theTitleLabel;
}

#pragma mark - lazy
- (UIView * )theChargetContentView{
    if (!_theChargetContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(335);
            make.height.mas_equalTo(550);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        _theChargetContentView = theView;
        
    }
    return _theChargetContentView;
}

- (UIButton * )theCloseButton{
    if (!_theCloseButton) {
        UIButton * theView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.theChargetContentView addSubview:theView];
        [theView setImage:[PPImageUtil imageNamed:@"ico_game_close"] forState:UIControlStateNormal];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.theChargetContentView);
            make.right.equalTo(self.theChargetContentView);
            make.width.and.height.mas_equalTo(SF_Float(100));
        }];
        theView.tintColor = [UIColor blackColor];
        [theView addTarget:self action:@selector(onDissmissContentView) forControlEvents:UIControlEventTouchUpInside];
        _theCloseButton = theView;
    }
    return _theCloseButton;
}

- (UIImageView * )theChargeBgImageView{
    if (!_theChargeBgImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.theChargetContentView);
        }];
        theView.image = [PPImageUtil imageNamed:@"img_game_alert_coin_bg_ver_a"];
        _theChargeBgImageView = theView;
    }
    return _theChargeBgImageView;
}

@end
