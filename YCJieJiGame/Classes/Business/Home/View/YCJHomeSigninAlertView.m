//
//  YCJHomeSigninAlertView.m
//  YCJieJiGame
//
//  Created by zza on 2023/5/25.
//

#import "YCJHomeSigninAlertView.h"
#import "GradientButton.h"
#import "YCJSigninContentView.h"
#import "YCJSigninBigContentView.h"
#import "YCJSignInListModel.h"

@interface YCJHomeSigninAlertView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) GradientButton      *sureBtn;
@property (nonatomic, strong) UIButton             *closeBtn;

@end

@implementation YCJHomeSigninAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setListModel:(YCJSignInListModel *)listModel {
    CGFloat padding = 15;
    CGFloat width = (kScreenWidth - 90 - 60) / 3;
    for (int i = 0; i < listModel.list.count - 1; i++) {
        int row = i / 3;
        int column = i % 3;
        YCJSigninContentView *content = [[YCJSigninContentView alloc] init];
        content.detailModel = listModel.list[i];
        content.frame = CGRectMake(padding + (width + padding) * column, 120 + 110 * row, width, 100);
        [self.contentView addSubview:content];
    }
    
    YCJSigninBigContentView *big = [[YCJSigninBigContentView alloc] init];
    big.frame = CGRectMake(15, 350, kScreenWidth - 90 - 30, 100);
    big.detailModel = listModel.list[listModel.list.count - 1];
    [self.contentView addSubview:big];
    
    if ([listModel.status isEqualToString:@"1"]) {
        [self.sureBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:kColorHex(0x4F3E0B) forState:UIControlStateNormal];
        [self.sureBtn setGradientBgColor];
    } else {
        [self.sureBtn setNormalBgColorWithColor:kColorHex(0xEDEDED)];
        [self.sureBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:kColorHex(0x999999) forState:UIControlStateNormal];
    }
}

- (void)sureSignIn {
    [JKNetWorkManager postRequestWithUrlPath:JKSigninUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        [self dismiss];
        if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"签到成功"];
            [[YCJUserInfoManager sharedInstance] reloadUserInfo];
        } else {
            [MBProgressHUD showSuccess:result.resultObject[@"errMsg"]];
        }
    }];
}

- (void)setupSubviews {
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 90);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
        make.height.mas_equalTo(520);
    }];
    
    [self.contentView insertSubview:self.contentBgView atIndex:0];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(180);
        make.centerY.equalTo(self.contentBgView.mas_bottom);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(50);
        make.top.equalTo(self.contentView.mas_bottom).offset(60);
    }];
}

- (void)show {
    /// 初始化视图
    [self setupSubviews];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];

    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureBtnAction {
    [self sureSignIn];
}

- (void)closeAction {
    [self dismiss];
}


#pragma mark -- lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentBgView.image = [UIImage imageNamed:@"icon_home_signin_bg"];
    }
    return _contentBgView;
}


- (GradientButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[GradientButton alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        [_sureBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kColorHex(0x4F3E0B) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangMediumFont(18);
        _sureBtn.cornerRadius = 25;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
