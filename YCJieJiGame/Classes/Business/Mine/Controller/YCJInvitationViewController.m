//
//  YCJInvitationViewController.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/24.
//

#import "YCJInvitationViewController.h"
#import "YCJInvitionCodeView.h"
#import "YCJInputItemView.h"
#import "YCJInvitionRemindView.h"
#import "UIImage+Extras.h"
#import "YCJInviteCodeModel.h"
#import "YCJInvitationCodeAlertView.h"

@interface YCJInvitationViewController ()
@property (nonatomic, strong) UIScrollView              *scrollView;
@property (nonatomic, strong) UIImageView               *contentBgView;
@property (nonatomic, strong) UIImageView               *contentCodeBgView;
@property (nonatomic, strong) UIView                    *inviteCodeBgView;
@property (nonatomic, strong) YCJInvitionRemindView     *remindView;
@property (nonatomic, strong) UIImageView               *contentCodeBgView1;
@property (nonatomic, strong) UILabel                   *codeLB;
@property (nonatomic, strong) YCJInvitionCodeView       *codeView;
@property (nonatomic, strong) UITextField               *inputCodeTF;
@property (nonatomic, strong) UILabel                   *invitionLB;
@property (nonatomic, strong) UIButton                  *sureBtn;
@property (nonatomic, strong) UIButton                  *invitionBtn;
@property (nonatomic, strong) UIView                    *arrowBgView;
@property (nonatomic, strong) UIImageView               *arrowImg;
@property (nonatomic, strong) YCJInviteCodeModel        *inviteModel;
@end

@implementation YCJInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请好友";
    [self bgImageName:@"icon_mine_invitation_bg"];
    [self configUI];
    [self requestInviteData];
}

- (void)requestInviteData {
    [JKNetWorkManager getRequestWithUrlPath:JKInviteCodeInfoUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        WeakSelf
        if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
            weakSelf.inviteModel = [YCJInviteCodeModel mj_objectWithKeyValues:result.resultData];
            weakSelf.codeView.inviteModel = weakSelf.inviteModel;
            weakSelf.remindView.inviteModel = weakSelf.inviteModel;
        }
    }];
}

- (void)configUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.equalTo(self.view).offset(-kMargin);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + 100);
        make.height.mas_equalTo(kSize(380));
    }];
    
    [self.contentBgView addSubview:self.contentCodeBgView];
    [self.contentCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(30);
    }];
    
    [self.contentBgView addSubview:self.codeLB];
    [self.codeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(55);
    }];
    
    [self.contentBgView addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_offset(-kMargin);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentBgView addSubview:self.remindView];
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(150);
    }];
    
    [self.contentBgView addSubview:self.invitionBtn];
    [self.invitionBtn addSubview:self.arrowBgView];
    [self.invitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentBgView);
        make.height.mas_equalTo(70);
    }];
    [self.arrowBgView addSubview:self.arrowImg];
    [self.arrowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.invitionBtn);
        make.size.mas_equalTo(20);
        make.left.equalTo(self.invitionBtn.mas_centerX).offset(65);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(4);
        make.right.bottom.mas_equalTo(-4);
    }];
    
    [self.scrollView addSubview:self.inviteCodeBgView];
    [self.inviteCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.equalTo(self.view).offset(-kMargin);
        make.top.equalTo(self.contentBgView.mas_bottom).offset(20);
        make.height.mas_equalTo(kSize(170));
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).inset(20);
    }];
    
    [self.inviteCodeBgView addSubview:self.contentCodeBgView1];
    [self.contentCodeBgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inviteCodeBgView);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(30);
    }];
    
    [self.inviteCodeBgView addSubview:self.invitionLB];
    [self.invitionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inviteCodeBgView);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(55);
    }];
    
    [self.inviteCodeBgView addSubview:self.inputCodeTF];
    [self.inputCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inviteCodeBgView).offset(20);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.inviteCodeBgView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inviteCodeBgView).offset(20);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(130);
        make.right.mas_equalTo(-24);
    }];
}

- (void)invitionAction {
    NSLog(@"邀请微信好友");
}

- (void)sureBtnAction {
    [self submitInviteCode];
}

#pragma mark - loadData
- (void)submitInviteCode {
    
    if (self.inputCodeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入邀请码"];
        return;
    }
    [JKNetWorkManager postRequestWithUrlPath:JKInputInviteCodeUrlKey parameters:@{@"code": self.inputCodeTF.text} finished:^(JKNetWorkResult * _Nonnull result) {
        [MBProgressHUD hideHUD];
        [self.view endEditing:YES];
        self.inputCodeTF.text = @"";
        [MBProgressHUD hideHUD];
        kRunAfter(0.3, ^{
            [MBProgressHUD showError:result.resultObject[@"errMsg"]];
        });
        [[YCJUserInfoManager sharedInstance] reloadUserInfo];
    }];
}

#pragma mark —— lazyLoad
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleToFill;
        _contentBgView.image = [UIImage imageNamed:@"icon_mine_invitation_content"];
    }
    return _contentBgView;
}


- (UIImageView *)contentCodeBgView{
    if (!_contentCodeBgView) {
        _contentCodeBgView = [UIImageView new];
        _contentCodeBgView.contentMode = UIViewContentModeScaleToFill;
        _contentCodeBgView.image = [UIImage imageNamed:@"icon_mine_invitation_code"];
    }
    return _contentCodeBgView;
}

- (UIView *)inviteCodeBgView {
    if (!_inviteCodeBgView) {
        _inviteCodeBgView = [[UIView alloc] init];
        _inviteCodeBgView.backgroundColor = kColorHex(0xFFFEF8);
        _inviteCodeBgView.cornerRadius = kSize(8);
    }
    return _inviteCodeBgView;
}


- (UIImageView *)contentCodeBgView1 {
    if (!_contentCodeBgView1) {
        _contentCodeBgView1 = [UIImageView new];
        _contentCodeBgView1.contentMode = UIViewContentModeScaleToFill;
        _contentCodeBgView1.image = [UIImage imageNamed:@"icon_mine_invitation_code"];
    }
    return _contentCodeBgView1;
}

- (UILabel *)codeLB {
    if (!_codeLB) {
        _codeLB = [[UILabel alloc] init];
        _codeLB.text = @"您的专属邀请码";
        _codeLB.textAlignment = NSTextAlignmentCenter;
        _codeLB.font = kPingFangSemiboldFont(16);
        _codeLB.textColor = kColorHex(0x222222);
    }
    return _codeLB;
}

- (YCJInvitionCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[YCJInvitionCodeView alloc] init];
    }
    return _codeView;
}

- (UILabel *)invitionLB {
    if (!_invitionLB) {
        _invitionLB = [[UILabel alloc] init];
        _invitionLB.text = @"填写好友邀请码";
        _invitionLB.textAlignment = NSTextAlignmentCenter;
        _invitionLB.font = kPingFangSemiboldFont(16);
        _invitionLB.textColor = kColorHex(0x222222);
    }
    return _invitionLB;
}


- (UITextField *)inputCodeTF {
    if (!_inputCodeTF) {
        _inputCodeTF = [YCJInputItemView createTextFieldWithPlaceHolder:@"请输入"];
        _inputCodeTF.cornerRadius = 25;
        _inputCodeTF.borderColor = kColorHex(0xF8F6E9);
        _inputCodeTF.borderWidth = 1.5;
        _inputCodeTF.backgroundColor = kColorHex(0xF8F6E9);
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 18, 1);
        _inputCodeTF.leftView = left;
        _inputCodeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _inputCodeTF;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangMediumFont(16);
        _sureBtn.backgroundColor = kColorHex(0xE58D24);
        _sureBtn.cornerRadius = 19;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (YCJInvitionRemindView *)remindView {
    if (!_remindView) {
        _remindView = [[YCJInvitionRemindView alloc] init];
    }
    return _remindView;
}

- (UIButton *)invitionBtn {
    if (!_invitionBtn) {
        _invitionBtn = [[UIButton alloc] init];
        [_invitionBtn setTitle:@"邀请微信好友" forState:UIControlStateNormal];
        [_invitionBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _invitionBtn.titleLabel.font = kPingFangRegularFont(16);
        [_invitionBtn addTarget:self action:@selector(invitionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invitionBtn;
}


- (UIView *)arrowBgView {
    if (!_arrowBgView) {
        _arrowBgView = [UIView new];
        _arrowBgView.backgroundColor = kCommonWhiteColor;
        _arrowBgView.cornerRadius = 10;
    }
    return _arrowBgView;
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImg.image = [UIImage imageWithImageName:@"icon_mine_arrowR" imageColor:kColorHex(0xE58D24)];
    }
    return _arrowImg;
}

@end
