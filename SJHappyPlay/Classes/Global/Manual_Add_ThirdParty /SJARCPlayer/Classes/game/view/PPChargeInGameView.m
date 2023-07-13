#import "PPChargeInGameView.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "PPImageUtil.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPChargetCoinCollectionViewCell.h"
#import <WebKit/WebKit.h>
#import "SJUserRechargeCoinDataView.h"
#import "AppDefineHeader.h"
#import "SDRechargeWebViewController.h"
#import "SJRechargeCoinCollectionViewCell.h"

@interface PPChargeInGameView ()<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) NSString * moduleName;
@property (nonatomic, weak) UIView * theChargetContentView;
@property (nonatomic, weak) UIImageView * theChargeBgImageView;
@property (nonatomic, weak) UIButton * theCloseButton;
@property (nonatomic, weak) UILabel * theChargeTitleLabel;
@property (nonatomic, weak) UILabel * theLastMoneyLabel;
@property (nonatomic, weak) UICollectionView * theChargetCollectionView;
@property (nonatomic, weak) UILabel * theLastPointLabel;
@property (nonatomic, weak) WKWebView * theWebView;
@property (nonatomic,strong) SJUserRechargeCoinDataView *coinDataView;

@end
@implementation PPChargeInGameView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chargetSubject = [RACSubject subject];
        [self configView];
    }
    return self;
}
#pragma mark - config
- (void)configView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDissmissGesture:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    [self theChargetContentView];
    [self theChargeBgImageView];
    [self theCloseButton];
    self.alpha = 0;
    [self coinDataView];
}
#pragma mark - action
- (void)onTapDissmissGesture:(UIGestureRecognizer * )gesture {
    [self onDissmissContentView];
}
- (void)onDissmissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissChargeController)]) {
            [self.delegate dissmissChargeController];
        }
    }];
}
#pragma mark - public method
- (void)showChargeInGame {
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^{               
        self.transform = CGAffineTransformIdentity;
    }];
    [self.theChargetCollectionView reloadData];
}
- (void)showChargeAliPayData:(NSString *) data {
    
    [self.theWebView loadHTMLString:data baseURL: nil];
}
#pragma mark - set
- (void)setCurrentPriceValue:(NSString *)currentPriceValue {
    _currentPriceValue = currentPriceValue;
    self.coinDataView.priceValue = currentPriceValue;
}
- (void)setCurrentPointValue:(NSString *)currentPointValue {
    _currentPointValue = currentPointValue;
    self.coinDataView.pointValue = currentPointValue;
}
- (void)setCurrentStoneValue:(NSString *)currentStoneValue {
    _currentStoneValue = currentStoneValue;
    self.coinDataView.stoneValue = currentStoneValue;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.theChargetContentView.frame, touchPoint)) {
        return false;
    }
    return true;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chargeList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.chargeForMethod) {
        PPChargetCoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PPChargetCoinCollectionViewCell" forIndexPath:indexPath];
        PPChargetCoinData * data = self.chargeList[indexPath.row];
        [cell loadCoinModel:data];
        return cell;
    } else {
        SJRechargeCoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJRechargeCoinCollectionViewCell" forIndexPath:indexPath];
        PPChargetCoinData * data = self.chargeList[indexPath.row];
        [cell loadCoinModel:data];
        return cell;
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PPChargetCoinData * data = self.chargeList[indexPath.row];    
    [self.chargetSubject sendNext:data];
}
#pragma mark - WKNavigationDelegate
- (void)                  webView:(WKWebView *)webView
  decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                  decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSString * url = (request.URL).absoluteString;
    if ([url hasPrefix:@"alipay://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        [self onDissmissContentView];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - set
- (void)setChargeForMethod:(SDChargeInGameForMethod)chargeForMethod {
    _chargeForMethod = chargeForMethod;
    if (self.chargeForMethod == SDChargeInGameForCoin) {
        self.moduleName = @"chargeInGameForCoin";
        self.theChargeTitleLabel.text = ZCLocal(@"充值");
    } else {
        self.moduleName = @"chargeInGameForCoinByPoint";
        self.theChargeTitleLabel.text = ZCLocal(@"积分兑换");
    }
}
#pragma mark - lazy
- (UIView * )theChargetContentView{
    if (!_theChargetContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(550);
            make.height.mas_equalTo(SF_Float(550));
            make.center.equalTo(self);
        }];
        _theChargetContentView = theView;
    }
    return _theChargetContentView;
}
- (UIImageView * )theChargeBgImageView{
    if (!_theChargeBgImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.theChargetContentView);
        }];
        theView.image = [PPImageUtil imageNamed:@"img_game_alert_coin_bg_a"];
        _theChargeBgImageView = theView;
    }
    return _theChargeBgImageView;
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
- (UILabel * )theChargeTitleLabel{
    if (!_theChargeTitleLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theChargetContentView);
            make.top.equalTo(self.theChargetContentView).offset(SF_Float(44));
        }];
        theView.textColor = [UIColor whiteColor];
        theView.font = AutoBoldPxFont(36);
        theView.text = ZCLocal(@"充值");
        _theChargeTitleLabel = theView;
    }
    return _theChargeTitleLabel;
}
- (UILabel * )theLastMoneyLabel{
    if (!_theLastMoneyLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theChargetContentView).offset(SF_Float(32));
            make.top.equalTo(self.theChargetContentView).offset(SF_Float(106));
        }];
        theView.font = AutoPxFont(28);
        theView.textColor = [UIColor colorForHex:@"#333333"];
        _theLastMoneyLabel = theView;
    }
    return _theLastMoneyLabel;
}
- (UILabel * )theLastPointLabel{
    if (!_theLastPointLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theChargetContentView addSubview:theView];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theLastMoneyLabel.mas_right).offset(SF_Float(20));
            make.top.equalTo(self.theChargetContentView).offset(SF_Float(106));
        }];
        theView.font = AutoPxFont(28);
        theView.textColor = [UIColor colorForHex:@"#333333"];
        _theLastPointLabel = theView;
    }
    return _theLastPointLabel;
}
- (UICollectionView * )theChargetCollectionView{
    if (!_theChargetCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SF_Float(280), SF_Float(292));
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.theChargetContentView addSubview:theView];
        [theView registerClass:[PPChargetCoinCollectionViewCell class] forCellWithReuseIdentifier:@"PPChargetCoinCollectionViewCell"];
        [theView registerClass:[SJRechargeCoinCollectionViewCell class] forCellWithReuseIdentifier:@"SJRechargeCoinCollectionViewCell"];
        theView.dataSource = self;
        theView.delegate = self;
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theChargetContentView);
            make.right.equalTo(self.theChargetContentView.mas_right);
            make.bottom.equalTo(self.theChargetContentView.mas_bottom).inset(DSize(40));
            make.height.mas_equalTo(SF_Float(292));
        }];
        [theView setContentInset:UIEdgeInsetsMake(0, SF_Float(30), 0, SF_Float(30))];
        theView.backgroundColor = [UIColor clearColor];
        theView.showsHorizontalScrollIndicator = NO;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _theChargetCollectionView = theView;
    }
    return _theChargetCollectionView;
}
- (WKWebView *)theWebView{
    if (!_theWebView) {
        WKWebView * theView = [[WKWebView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
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
            make.width.mas_equalTo(DSize(600));
        }];
    }
    return _coinDataView;
}

@end
