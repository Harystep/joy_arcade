//
//  YCJSMSLoginViewController.m
//  YCJieJiGame
//
//  Created by zza on 2023/6/1.
//

#import "YCJSMSLoginViewController.h"
#import "YCJInputItemView.h"

@interface YCJSMSLoginViewController ()

@property (nonatomic, strong) UILabel       *phoneLB;
@property (nonatomic, strong) UITextField   *phoneTF;
@property (nonatomic, strong) UILabel       *smsLB;
@property (nonatomic, strong) UITextField   *smsTF;
@property (nonatomic, strong) UIButton      *loginBtn;
@property (nonatomic, strong) UIButton      *smsBtn;
@property (nonatomic, strong) UIView        *line1View;
@property (nonatomic, strong) UIView        *line2View;
@end

@implementation YCJSMSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonBlackColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.phoneLB];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.line1View];
    [self.view addSubview:self.smsLB];
    [self.view addSubview:self.smsTF];
    [self.view addSubview:self.smsBtn];
    [self.view addSubview:self.line2View];
    [self.view addSubview:self.loginBtn];
    
    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + 40);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.phoneLB.mas_bottom).offset(10);
    }];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTF);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.phoneTF.mas_bottom);
    }];
    
    [self.smsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.line1View.mas_bottom).offset(20);
    }];
    [self.smsTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-40);
        make.top.equalTo(self.smsLB.mas_bottom).offset(10);
    }];
    [self.smsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.smsTF).offset(-20);
        make.right.equalTo(self.smsTF.mas_right);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.smsTF);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.smsTF.mas_bottom);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(270);
        make.top.equalTo(self.line2View.mas_bottom).offset(40);
    }];
}



- (void)loginAction {
    NSLog(@"登录");
}

- (UILabel *)phoneLB {
    if (!_phoneLB) {
        _phoneLB = [[UILabel alloc] init];
        _phoneLB.text = @"手机号码";
        _phoneLB.textAlignment = NSTextAlignmentLeft;
        _phoneLB.font = kPingFangMediumFont(14);
        _phoneLB.textColor = kCommonBlackColor;
    }
    return _phoneLB;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [YCJInputItemView createTextFieldWithPlaceHolder:@"请输入手机号码"];
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _phoneTF.leftView = left;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTF;
}

- (UILabel *)smsLB {
    if (!_smsLB) {
        _smsLB = [[UILabel alloc] init];
        _smsLB.text = @"短信验证";
        _smsLB.textAlignment = NSTextAlignmentLeft;
        _smsLB.font = kPingFangMediumFont(14);
        _smsLB.textColor = kCommonBlackColor;
    }
    return _smsLB;
}

- (UITextField *)smsTF {
    if (!_smsTF) {
        _smsTF = [YCJInputItemView createTextFieldWithPlaceHolder:@"请输入短信验证码"];
        UIView *left = [[UIView alloc] init];
        left.frame = CGRectMake(0, 0, 12, 1);
        _smsTF.leftView = left;
        _smsTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _smsTF;
}


-(UIButton *)loginBtn {
    if(!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kColorHex(0xF6F6F6) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = kPingFangRegularFont(16);
        _loginBtn.backgroundColor = kColorHex(0xDD981B);
        _loginBtn.cornerRadius = kSize(10);
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}


-(UIButton *)smsBtn {
    if(!_smsBtn) {
        _smsBtn = [[UIButton alloc] init];
        [_smsBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_smsBtn setTitleColor:kColorHex(0xDD981B) forState:UIControlStateNormal];
        _smsBtn.titleLabel.font = kPingFangRegularFont(16);
        _smsBtn.borderColor = kColorHex(0xDD981B);
        _smsBtn.borderWidth = 1;
        _smsBtn.cornerRadius = kSize(6);
        [_smsBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsBtn;
}

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = kColorHex(0xDFDFDF);
    }
    return _line1View;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = kColorHex(0xDFDFDF);
    }
    return _line2View;
}
@end
