//
//  YCJInvitationCodeAlertView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/22.
//

#import "YCJInvitationCodeAlertView.h"
#import "YCJInputItemView.h"
#import "YCJInviteCodeModel.h"

@interface YCJInvitationCodeAlertView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UITextField   *inviteCodeTF;
@property (nonatomic, strong) UILabel       *inviteLB;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;

@end

@implementation YCJInvitationCodeAlertView


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
    
    [self.contentView addSubview:self.inviteCodeTF];
    [self.inviteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.inviteLB];
    [self.inviteLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.inviteCodeTF.mas_bottom).offset(5);
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
        make.top.equalTo(self.inviteLB.mas_bottom).offset(20);
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
    
    if (self.inviteCodeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入邀请码"];
        return;
    }
    WeakSelf
    [JKNetWorkManager postRequestWithUrlPath:JKInputInviteCodeUrlKey parameters:@{@"code": self.inviteCodeTF.text} finished:^(JKNetWorkResult * _Nonnull result) {
        [MBProgressHUD hideHUD];
        kRunAfter(0.3, ^{
            [MBProgressHUD showError:result.resultObject[@"errMsg"]];
        });
        [[YCJUserInfoManager sharedInstance] reloadUserInfo];
        [weakSelf dismiss];
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
        _titleLB.text = @"填写邀请码";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(15);
        _titleLB.textColor = kCommonBlackColor;
    }
    return _titleLB;
}

- (UILabel *)inviteLB {
    if (!_inviteLB) {
        _inviteLB = [[UILabel alloc] init];
        _inviteLB.text = @"每天只能填写一次";
        _inviteLB.hidden = YES;
        _inviteLB.textAlignment = NSTextAlignmentLeft;
        _inviteLB.font = kPingFangRegularFont(12);
        _inviteLB.textColor = kLightBlackColor;
    }
    return _inviteLB;
}

- (UITextField *)inviteCodeTF {
    if (!_inviteCodeTF) {
        _inviteCodeTF = [YCJInputItemView createTextFieldWithPlaceHolder:@"请输入"];
        _inviteCodeTF.cornerRadius = kSize(8);
        _inviteCodeTF.backgroundColor = kColorHex(0xECECEC);
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _inviteCodeTF.leftView = left;
        _inviteCodeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _inviteCodeTF;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
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
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangRegularFont(14);
        _sureBtn.backgroundColor = kColorHex(0x6984EA);
        _sureBtn.cornerRadius = kSize(4);
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
