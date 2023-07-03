

#import "YCJNickNameModifyView.h"
#import "YCJInputItemView.h"

@interface YCJNickNameModifyView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UITextField   *nameTF;
@property (nonatomic, strong) UILabel       *nameLB;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;

@end

@implementation YCJNickNameModifyView


- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(45));
        make.right.mas_equalTo(-kSize(45));
        make.centerY.equalTo(self);
    }];
    
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.nameTF.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
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
        make.top.equalTo(self.nameLB.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
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
    [self endEditing:YES];
    if (self.commonAlertViewDoneClickBlock) {
        self.commonAlertViewDoneClickBlock();
    }
    if (self.nameTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入新的昵称"];
        return;
    }
    [JKNetWorkManager postRequestWithUrlPath:JKAccountModifyUrlKey parameters:@{@"accessToken":[SKUserInfoManager sharedInstance].userTokenModel.accessToken, @"nickname": self.nameTF.text} finished:^(JKNetWorkResult * _Nonnull result) {
        [self dismiss];
        if (!result.error && [result.resultObject[@"msg"] intValue] == 0) {
            [[SKUserInfoManager sharedInstance] reloadUserInfo];
            [MBProgressHUD showSuccess:@"修改成功"];
        } else {
            [MBProgressHUD showError:result.resultObject[@"msg"]];
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
        _titleLB.text = ZCLocalizedString(@"修改用户昵称", nil);
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(15);
        _titleLB.textColor = kCommonBlackColor;
    }
    return _titleLB;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.text = ZCLocalizedString(@"请输入6位以内的用户昵称", nil);
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.font = kPingFangRegularFont(12);
        _nameLB.textColor = kLightBlackColor;
    }
    return _nameLB;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [YCJInputItemView createTextFieldWithPlaceHolder:ZCLocalizedString(@"请输入昵称", nil)];
        _nameTF.cornerRadius = kSize(8);
        _nameTF.backgroundColor = kColorHex(0xECECEC);
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _nameTF.leftView = left;
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTF;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:ZCLocalizedString(@"取消", nil) forState:UIControlStateNormal];
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
