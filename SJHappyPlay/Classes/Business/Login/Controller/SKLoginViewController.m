
#import "SKLoginViewController.h"
#import "SKSMSLoginViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <ATAuthSDK/ATAuthSDK.h>
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>

@interface SKLoginViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) UIImageView       *topImgView;
@property (nonatomic, strong) UIView            *contentBgView;
@property (nonatomic, strong) UILabel           *phoneLabel;
@property (nonatomic, strong) UILabel           *cerLabel;
@property (nonatomic, strong) UIButton          *loginBtn;
@property (nonatomic, strong) UILabel           *otherLabel;
@property (nonatomic, strong) YYLabel           *yonghuxieyiLB;
@property (nonatomic, strong) UIButton          *appleBtn;
@property (nonatomic, strong) UIButton          *smsBtn;
@property (nonatomic, copy) NSString            *phone;
  
@end

@implementation SKLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self centerButton:self.appleBtn];
    [self centerButton:self.smsBtn];
        
}

- (void)requestPhone:(NSString *)token {
    WeakSelf
    [JKNetWorkManager postRequestWithUrlPath:JKALYPhoneGetUrlKey parameters:@{@"loginToken": token} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else {
            weakSelf.phone = result.resultObject[@"data"];
            NSLog(@"获取本机手机号：%@", weakSelf.phone);
            weakSelf.phoneLabel.text = [NSString secrectMobileString:weakSelf.phone];
            [self onekeyPhoneLogin];
        }
    }];
}

- (void)onekeyPhoneLogin {
    [MBProgressHUD showLoadingMessage:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phone forKey:@"mobile"];
    NSString *sign = [NSString stringWithFormat:@"%@@@%@", self.phone, self.phone];
    [param setObject:[sign md5] forKey:@"sign"];
    [JKNetWorkManager postRequestWithUrlPath:JKOneKeyLoginUrlKey parameters:[param copy] finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else{
            /// 保存用户信息
            SKUserInfoModel *userInfoModel = [SKUserInfoModel mj_objectWithKeyValues:result.resultData];
            YCJToken *tokenModel = [YCJToken mj_objectWithKeyValues:result.resultData[@"accessToken"]];
            [SKUserInfoManager sharedInstance].userInfoModel = userInfoModel;
            [SKUserInfoManager sharedInstance].userTokenModel = tokenModel;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)appleLogin:(NSDictionary *)param {
    [MBProgressHUD showLoadingMessage:@""];
    [JKNetWorkManager postRequestWithUrlPath:JKAppleLoginUrlKey parameters:param finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else{
            /// 保存用户信息
            SKUserInfoModel *userInfoModel = [SKUserInfoModel mj_objectWithKeyValues:result.resultData];
            YCJToken *tokenModel = [YCJToken mj_objectWithKeyValues:result.resultData[@"accessToken"]];
            [SKUserInfoManager sharedInstance].userInfoModel = userInfoModel;
            [SKUserInfoManager sharedInstance].userTokenModel = tokenModel;
            [[SKUserInfoManager sharedInstance] reloadUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)configUI {
    
    [self.view addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(265);
    }];
    
    [self.view addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(255);
    }];
    
    [self.contentBgView addSubview:self.phoneLabel];
    [self.contentBgView addSubview:self.cerLabel];
    [self.contentBgView addSubview:self.loginBtn];
    [self.contentBgView addSubview:self.otherLabel];
    [self.contentBgView addSubview:self.appleBtn];
    [self.contentBgView addSubview:self.smsBtn];
    [self.contentBgView addSubview:self.yonghuxieyiLB];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(60);
    }];
    
    [self.cerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.phoneLabel).offset(60);
    }];
    
    if([SJLocalTool getCurrentLanguage] == 3) {
        self.loginBtn.hidden = YES;
        [self.appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentBgView.mas_centerY).offset(-50);
            make.height.mas_equalTo(70);
            make.width.mas_equalTo(50);
            make.centerX.equalTo(self.contentBgView.mas_centerX);
        }];
    } else {
        self.loginBtn.hidden = NO;
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBgView);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(270);
            make.top.equalTo(self.cerLabel).offset(1);
        }];
        [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBgView);
            make.height.mas_equalTo(30);
            make.top.equalTo(self.loginBtn).offset(100);
        }];
        [self.appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.otherLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(70);
            make.width.mas_equalTo(50);
            make.centerX.equalTo(self.contentBgView.mas_centerX);
        }];
    }
    
    [self.yonghuxieyiLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.height.mas_equalTo(40);
        make.leading.trailing.mas_equalTo(self.contentBgView).inset(20);
        make.bottom.mas_equalTo(self.contentBgView.mas_bottom).inset(50);
    }];
   
}

- (void)centerButton:(UIButton *)button{
    button.backgroundColor = [UIColor clearColor];
    CGSize buttonSize = button.frame.size;
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    
    /// 图片的向上偏移titleLabel的高度（如果觉得图片和文字挨的太近，可以增加向上的值）【负值】，0，0，图片右边偏移偏移按钮的宽减去图片的宽然后除以2【正值】
    [button setImageEdgeInsets:UIEdgeInsetsMake(-(titleSize.height) - 8, 0, 0, (buttonSize.width - imageSize.width) / 2)];
    /// 文字的向上偏移图片的高度【正值】，向左偏移图片的宽带【负值】，0，0
    [button setTitleEdgeInsets:UIEdgeInsetsMake((imageSize.height) ,-(imageSize.width), 0,0)];
}

- (void)loginAction:(UIButton *)send {
    NSLog(@"登录");
    /// 80: 本机号码一键登录，90：Apple登录，100：验证码登录
    if (send.tag == 80) {
        [self ownPhoneLogin];
    } else if (send.tag == 90) {
        [self appleLoginAction];
    } else if (send.tag == 100) {
        SKSMSLoginViewController *vc = [[SKSMSLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark -- 阿里云一键登录页面
- (void)ownPhoneLogin {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginClickPrivacyAlertView isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClickContinue isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClose isEqualToString:resultCode]) {
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if([PNSCodeLoginControllerClickProtocol isEqualToString:resultCode] ||
                 [PNSCodeLoginPrivacyAlertViewPrivacyContentClick isEqualToString:resultCode]){
            NSLog(@"页面点击事件回调：%@", resultDic);
            NSString *privacyUrl = [resultDic objectForKey:@"url"];
            NSString *privacyName = [resultDic objectForKey:@"urlName"];
            NSLog(@"如果TXCustomModel的privacyVCIsCustomized设置成YES，则SDK内部不会跳转协议页，需要自己实现");
            if(model.privacyVCIsCustomized){
//                PrivacyWebViewController *controller = [[PrivacyWebViewController alloc] initWithUrl:privacyUrl andUrlName:privacyName];
//                controller.isHiddenNavgationBar = NO;
//                UINavigationController *navigationController = weakSelf.navigationController;
//                if (weakSelf.presentedViewController) {
//                    //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
//                    navigationController = (UINavigationController *)weakSelf.presentedViewController;
//                }
//                [navigationController pushViewController:controller animated:YES];
            }
        } else if ([PNSCodeLoginControllerSuspendDisMissVC isEqualToString:resultCode]) {
            NSLog(@"页面点击事件回调：%@", resultDic);
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            NSString *token = [resultDic objectForKey:@"token"];
            UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
            if ([token isKindOfClass:NSString.class]) {
                generalPasteboard.string = token;
            }
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            [self requestPhone:token];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:@"当前系统版本暂不支持一键登录，请使用苹果登录"];
            //失败后可以跳转到短信登录界面
//            PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
//            controller.isHiddenNavgationBar = NO;
//            UINavigationController *navigationController = weakSelf.navigationController;
//            if (weakSelf.presentedViewController) {
//                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
//                navigationController = (UINavigationController *)weakSelf.presentedViewController;
//            }
//            [navigationController pushViewController:controller animated:YES];
        }
    }];
}

#pragma mark -
#pragma mark -- apple 登录
- (void)appleLoginAction {

    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests: @[request]];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
    } else {
        PNSToast(self.view,@"苹果登陆仅支持iOS 13及以上",2);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *authorizeCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSString *fullName = [NSString stringWithFormat:@"%@%@", authorizeCredential.fullName.familyName, authorizeCredential.fullName.givenName];
        NSString *authorizationCode = [[NSString alloc] initWithData:authorizeCredential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *identityToken = [[NSString alloc] initWithData:authorizeCredential.identityToken encoding:NSUTF8StringEncoding];
        NSString *email = authorizeCredential.email;
        if (!email) {
            email = @"";
        }
        NSDictionary *param = @{@"userID": authorizeCredential.user, @"email": email, @"fullName": fullName, @"authorizationCode": authorizationCode, @"identityToken": identityToken};
        [self appleLogin:param];
        
        // 将ID保存到钥匙串
        // self.saveUserInKeychain(appleIDCredential.user)
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = (ASPasswordCredential *)authorization.credential;
        NSDictionary *param = @{@"userID": passwordCredential.user, @"password": passwordCredential.password};
        [self appleLogin:param];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = @"";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
        errorMsg = ZCLocalizedString(@"用户取消了授权请求", nil);
        break;
        case ASAuthorizationErrorFailed:
        errorMsg = ZCLocalizedString(@"授权请求失败", nil);
        break;
        case ASAuthorizationErrorInvalidResponse:
        errorMsg = ZCLocalizedString(@"授权请求响应无效", nil);
        break;
        case ASAuthorizationErrorNotHandled:
        errorMsg = ZCLocalizedString(@"未能处理授权请求", nil);
        break;
        case ASAuthorizationErrorUnknown:
        errorMsg = ZCLocalizedString(@"无法授权", nil);
        break;
     }
    PNSToast(self.view,errorMsg,2);
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)) {
    
    return self.view.window;
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIView new];
        _contentBgView.cornerRadius = kSize(12);
        _contentBgView.backgroundColor = [UIColor whiteColor];
    }
    return _contentBgView;
}

- (UIImageView *)topImgView {
    if (!_topImgView) {
        _topImgView = [UIImageView new];
        _topImgView.contentMode = UIViewContentModeScaleAspectFill;
        _topImgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_login_bg"]];
    }
    return _topImgView;
}


- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = kPingFangMediumFont(30);
        _phoneLabel.textColor = kCommonBlackColor;
        _phoneLabel.text = @"";
    }
    return _phoneLabel;
}
- (UILabel *)cerLabel{
    if (!_cerLabel) {
        _cerLabel = [UILabel new];
        _cerLabel.textAlignment = NSTextAlignmentCenter;
        _cerLabel.font = kPingFangMediumFont(12);
        _cerLabel.textColor = kColorHex(0x999999);
        _cerLabel.text = ZCLocalizedString(@"中国移动认证服务", nil);
        _cerLabel.hidden = YES;
    }
    return _cerLabel;
}

-(UIButton *)loginBtn {
    if(!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:ZCLocalizedString(@"本机号码一键登录", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kColorHex(0xF6F6F6) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = kPingFangRegularFont(16);
        _loginBtn.backgroundColor = kColorHex(0xDD981B);
        _loginBtn.cornerRadius = kSize(10);
        _loginBtn.tag = 80;
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)otherLabel{
    if (!_otherLabel) {
        _otherLabel = [UILabel new];
        _otherLabel.textAlignment = NSTextAlignmentCenter;
        _otherLabel.font = kPingFangMediumFont(12);
        _otherLabel.textColor = kColorHex(0x999999);
        _otherLabel.text = ZCLocalizedString(@"其他登录方式", nil);
    }
    return _otherLabel;
}

-(UIButton *)appleBtn {
    if(!_appleBtn) {
        _appleBtn = [[UIButton alloc] init];
        [_appleBtn setTitle:ZCLocalizedString(@"苹果账号", nil) forState:UIControlStateNormal];
        [_appleBtn setTitleColor:kColorHex(0x666666) forState:UIControlStateNormal];
        [_appleBtn setImage:[UIImage imageNamed:@"icon_login_apple"] forState:UIControlStateNormal];
        _appleBtn.tag = 90;
        _appleBtn.titleLabel.font = kPingFangRegularFont(12);
        [_appleBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appleBtn;
}

-(UIButton *)smsBtn {
    if(!_smsBtn) {
        _smsBtn = [[UIButton alloc] init];
        /// 先隐藏验证码登录
        [_smsBtn setHidden:YES];
        [_smsBtn setTitle:ZCLocalizedString(@"短信验证", nil) forState:UIControlStateNormal];
        [_smsBtn setTitleColor:kColorHex(0x666666) forState:UIControlStateNormal];
        [_smsBtn setImage:[UIImage imageNamed:@"icon_login_phone"] forState:UIControlStateNormal];
        _smsBtn.tag = 100;
        _smsBtn.titleLabel.font = kPingFangRegularFont(12);
        [_smsBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsBtn;
}

- (YYLabel *)yonghuxieyiLB {
    if (!_yonghuxieyiLB) {
        _yonghuxieyiLB = [[YYLabel alloc] init];
        NSString *operateStr = ZCLocalizedString(@"登录注册即代表您同意《用户协议和隐私条款》", nil);
        NSMutableAttributedString  *attriStr = [[NSMutableAttributedString alloc] initWithString:operateStr];
        _yonghuxieyiLB.font = kPingFangMediumFont(12);
        _yonghuxieyiLB.textColor = kColorHex(0x999999);
        _yonghuxieyiLB.numberOfLines = 0;
        NSRange range = [operateStr rangeOfString:ZCLocalizedString(@"《用户协议和", nil) options:NSCaseInsensitiveSearch];
        [attriStr yy_setTextHighlightRange:range color:kColorHex(0x3E63E4) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            QABaseWebViewController *web = [[QABaseWebViewController alloc] init];
            web.url = JKUserAgreementUrlKey;
            web.navigationItem.title = ZCLocalizedString(@"用户协议", nil);
            [self.navigationController pushViewController:web animated:YES];
        }];
        NSRange range1 = [operateStr rangeOfString:ZCLocalizedString(@"隐私条款》", nil) options:NSCaseInsensitiveSearch];
        [attriStr yy_setTextHighlightRange:range1 color:kColorHex(0x3E63E4) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            QABaseWebViewController *web = [[QABaseWebViewController alloc] init];
            web.url = JKPrivacyPolicyUrlKey;
            web.navigationItem.title = ZCLocalizedString(@"隐私政策", nil);
            [self.navigationController pushViewController:web animated:YES];
        }];
        _yonghuxieyiLB.attributedText = attriStr;
        // 必须重新赋一次，否则赋完attributed内容会重置对齐方式为默认
        _yonghuxieyiLB.textAlignment = NSTextAlignmentCenter;
    }
    return _yonghuxieyiLB;
}

@end
