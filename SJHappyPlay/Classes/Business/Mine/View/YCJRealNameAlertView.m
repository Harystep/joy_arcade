

#import "YCJRealNameAlertView.h"
#import "YCJInputItemView.h"

@interface YCJRealNameAlertView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UILabel       *contentLB;
@property (nonatomic, strong) UILabel       *nameLB;
@property (nonatomic, strong) UITextField   *nameTF;
@property (nonatomic, strong) UILabel       *idCardLB;
@property (nonatomic, strong) UITextField   *idCardTF;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;

@end

@implementation YCJRealNameAlertView

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)setupSubviews {
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(45));
        make.right.mas_equalTo(-kSize(45));
        make.centerY.equalTo(self.view).offset(-45);
    }];
    
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.contentLB];
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);        
    }];
    
    [self.contentView addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.contentLB.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.nameLB.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.idCardLB];
    [self.idCardLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.nameTF.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.idCardTF];
    [self.idCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.idCardLB.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.idCardTF.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

- (void)show:(QABaseViewController *)par {
    /// 初始化视图
    [self setupSubviews];
    /// 此处不能加在keyWindow上面，IQKeyboardManager 三方库不支持加在UIWindow上面的UITextField的键盘偏移处理
//    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.definesPresentationContext = YES;
    [par presentViewController:self animated:YES completion:nil];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.15 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self dismissModalViewControllerAnimated:YES];
    }];
}

- (void)sureBtnAction {
    if (self.nameTF.text.length <=0) {
        [MBProgressHUD showError:ZCLocalizedString(@"请输入姓名", nil)];
        return;
    }
    if (self.idCardTF.text.length <=0) {
        [MBProgressHUD showError:ZCLocalizedString(@"请输入实名身份证号码", nil)];
        return;
    }
    if (![NSString accurateIDCardWithFifteenOrEighteen:self.idCardTF.text]) {
        [MBProgressHUD showError:ZCLocalizedString(@"请输入正确实名身份证号码", nil)];
        return;
    }
    [JKNetWorkManager postRequestWithUrlPath:JKAccountAuthUrlKey parameters:@{@"name": self.nameTF.text, @"card": self.idCardTF.text} finished:^(JKNetWorkResult * _Nonnull result) {
        [self dismiss];
        if (!result.error && [result.resultObject[@"errCode"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"认证成功"];
            if (self.commonAlertViewDoneClickBlock) {
                self.commonAlertViewDoneClickBlock();
            }
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:result.error.localizedDescription];
        }
    }];
}


#pragma mark -- lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kCommonWhiteColor;
        _contentView.layer.cornerRadius = 9;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = ZCLocalizedString(@"实名认证", nil);
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(15);
        _titleLB.textColor = kCommonBlackColor;
    }
    return _titleLB;
}

- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.text = ZCLocalizedString(@"auth_desc_title", nil);
        _contentLB.textAlignment = NSTextAlignmentLeft;
        _contentLB.font = kPingFangLightFont(12);
        _contentLB.numberOfLines = 0;
        _contentLB.textColor = kCommonBlackColor;
    }
    return _contentLB;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.text = ZCLocalizedString(@"姓名", nil);
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.font = kPingFangMediumFont(14);
        _nameLB.textColor = kCommonBlackColor;
    }
    return _nameLB;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [YCJInputItemView createTextFieldWithPlaceHolder:ZCLocalizedString(@"请填写真实姓名", nil)];
        _nameTF.cornerRadius = kSize(8);
        _nameTF.backgroundColor = kColorHex(0xECECEC);
        _nameTF.keyboardType = UIKeyboardTypeDefault;
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _nameTF.leftView = left;
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTF;
}

- (UILabel *)idCardLB {
    if (!_idCardLB) {
        _idCardLB = [[UILabel alloc] init];
        _idCardLB.text = ZCLocalizedString(@"身份证号码", nil);
        _idCardLB.textAlignment = NSTextAlignmentLeft;
        _idCardLB.font = kPingFangMediumFont(14);
        _idCardLB.textColor = kCommonBlackColor;
    }
    return _idCardLB;
}

- (UITextField *)idCardTF {
    if (!_idCardTF) {
        _idCardTF = [YCJInputItemView createTextFieldWithPlaceHolder:ZCLocalizedString(@"请填写真实有效的身份证号码", nil)];
        _idCardTF.cornerRadius = kSize(8);
        _idCardTF.keyboardType = UIKeyboardTypeDefault;
        _idCardTF.backgroundColor = kColorHex(0xECECEC);
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _idCardTF.leftView = left;
        _idCardTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _idCardTF;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:ZCLocalizedString(@"返回游戏", nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColorHex(0x46599C) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kPingFangRegularFont(14);
        _cancelBtn.backgroundColor = kColorHex(0xEEF2FF);
        _cancelBtn.cornerRadius = kSize(4);
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:ZCLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangRegularFont(14);
        _sureBtn.backgroundColor = kColorHex(0x6984EA);
        _sureBtn.cornerRadius = kSize(4);
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
