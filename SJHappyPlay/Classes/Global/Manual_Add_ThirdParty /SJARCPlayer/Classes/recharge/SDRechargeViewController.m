//
//  SDRechargeViewController.m
//  Pods
//
//  Created by sander shan on 2022/10/14.
//

#import "SDRechargeViewController.h"

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
#import "SJRequestAppleCreateOrderModel.h"
#import "SJResponseAppleCreateOrderModel.h"

@interface SDRechargeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, WKNavigationDelegate>

@property (nonatomic, weak) UICollectionView * theCollectionView;

@property (nonnull, nonatomic, strong) NSMutableArray<SDRechargeUnitDataModel * >* dataList;

@property (nonatomic, strong) NSMutableArray<SDRechargeUnitDataModel *> * weekDataList;

@property (nonatomic, strong) PPApplePayModule * applePayModule;

@property (nonatomic, weak) WKWebView * theWebView;

@end

@implementation SDRechargeViewController


- (instancetype)initWithType:(SDRechargeType) type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.chargeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configData];
    [self configView];
}

- (void)configData{
    
    self.applePayModule = [PPApplePayModule sharedInstance];
    
    self.dataList = [NSMutableArray array];
    self.weekDataList = [NSMutableArray array];
    SJPCChargeListRequestModel * requestModel = [[SJPCChargeListRequestModel alloc] init];
    requestModel.type = [NSString stringWithFormat:@"%ld", self.chargeType];
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        SJPCChargeListResponseModel * result = (SJPCChargeListResponseModel *)responseModel;
        PCChargeTypeInfoModel * data = result.data;
        PPChargeUnitModel * daily_first_recharge = data.daily_first_recharge;
        if (daily_first_recharge != nil && daily_first_recharge.is_recharged == 0) {
            [self.dataList addObject: [[SDRechargeUnitDataModel alloc] initWithOriginData:daily_first_recharge]];
        }
//        if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
//            if(data.month != nil) {
//                [self.weekDataList addObject:[[SDRechargeUnitDataModel alloc] initWithOriginData:data.month]];
//            }
//            if(data.week != nil) {
//                [self.weekDataList addObject:[[SDRechargeUnitDataModel alloc] initWithOriginData:data.week]];
//            }
//            if(data.first != nil) {
//                [self.weekDataList addObject:[[SDRechargeUnitDataModel alloc] initWithOriginData:data.first]];
//            }
//        }
        [data.optionList enumerateObjectsUsingBlock:^(PPChargeUnitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SDRechargeUnitDataModel * itemData = [[SDRechargeUnitDataModel alloc] initWithOriginData:obj];
            [self.dataList addObject:itemData];
        }];
        [self.theCollectionView reloadData];
    }];
}
- (void)configView {
    [self theWebView];
    
    self.title = ZCLocal(@"充值");
    self.view.backgroundColor = [UIColor colorForHex:@"#F2F2F7"];
    UIImage * closeImg = [PPImageUtil getImage:@"ico_game_close"];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:closeImg style:UIBarButtonItemStyleDone target:self action:@selector(onCloseBarPress:)];
    rightBarItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationController.view.backgroundColor = UIColor.whiteColor;
}
#pragma mark - action
- (void)onCloseBarPress:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)showChargeAliPayData:(NSString*) payData {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [self.theWebView loadHTMLString:payData baseURL: nil];
    } else {
        SDRechargeWebViewController * webViewController = [[SDRechargeWebViewController alloc] initWithData:payData];
        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:webViewController animated:true completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataList.count;
    }
    return self.weekDataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SDRechargeUnitCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SDRechargeUnitCollectionViewCell" forIndexPath:indexPath];

        SDRechargeUnitDataModel * model = self.dataList[indexPath.row];
        [cell loadDataModel:model];
        return cell;

    } else {
        SDRechargeUnitCycleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SDRechargeUnitCycleCollectionViewCell" forIndexPath:indexPath];
        SDRechargeUnitDataModel * model = self.weekDataList[indexPath.row];
        [cell loadDataModel:model];
        return cell;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 1) {
        return CGSizeMake(DSize(330), DSize(260));
    }
    return CGSizeMake(DSize(330), DSize(220));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, DSize(30), 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SDRechargeUnitDataModel * model = self.dataList[indexPath.row];
        if (model.appleProductId) {
            [self chargeByApple:model.originData];
        } else {
            [self chargeByAli:model.originData];
        }
    } else {
        SDRechargeUnitDataModel * model = self.weekDataList[indexPath.row];
        if (model.appleProductId) {
            [self chargeByApple:model.originData];
        } else {
            [self chargeByAli:model.originData];
        }
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
                [self.view makeToast:@"支付失败"];
            }
        }];
        [self dismissViewControllerAnimated:true completion:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)chargeByAli:(PPChargeUnitModel *)coinData {
    [self showLoading];
    PPRequestBaseModel * request;
    if (coinData.type) {
        SJPCChargeRequestModel * requestModel = [[SJPCChargeRequestModel alloc] init];
        requestModel.type = 3;
        requestModel.b_id = coinData.chargeId;
        requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
        request = requestModel;
    } else {
        SJChargeCardRequestModel * requestModel =[[SJChargeCardRequestModel alloc] init];
        requestModel.type = 3;
        requestModel.cardId = coinData.chargeId;
        requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
        request = requestModel;

    }
    @weakify_self;
    [request requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        @strongify_self;
        [self hideLoading];
        if (!error) {
            PPChargeOtherPayResponseModel * otherPayResponseModel = (PPChargeOtherPayResponseModel *)responseModel;
            [self showChargeAliPayData:otherPayResponseModel.data];
        }
    }];
}

- (void)chargeByApple:(PPChargeUnitModel *)data {
    [self showLoading];
//    [[PPApplePayModule sharedInstance] pay:data.iosOption withOrderId:data.chargeId withBlock:^(NSString * _Nonnull receipt) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideLoading];
//            [self.view makeToast:@"支付成功"];
//        });
//    } withFaileBlock:^(NSString * _Nonnull errMessage) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideLoading];
//            [self.view makeToast:errMessage];
//        });
//    }];
}

- (void)showLoading {
  [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
    });
}

#pragma mark - lazy UI
- (UICollectionView *)theCollectionView{
    if (!_theCollectionView) {
        UICollectionViewFlowLayout * flowLayot = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        theView.dataSource = self;
        theView.delegate = self;
        theView.backgroundColor = [UIColor colorForHex:@"#F2F2F7"];
        theView.contentInset = UIEdgeInsetsMake(DSize(37), DSize(24), DSize(0), DSize(24));
        [theView registerClass:[SDRechargeUnitCollectionViewCell class] forCellWithReuseIdentifier:@"SDRechargeUnitCollectionViewCell"];
        [theView registerClass:[SDRechargeUnitCycleCollectionViewCell class] forCellWithReuseIdentifier:@"SDRechargeUnitCycleCollectionViewCell"];
        _theCollectionView = theView;
    }
    return _theCollectionView;
}
- (WKWebView *)theWebView{
  if (!_theWebView) {
    WKWebView * theView = [[WKWebView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
      theView.hidden = true;
    theView.navigationDelegate = self;
    _theWebView = theView;
  }
  return _theWebView;
}

@end
