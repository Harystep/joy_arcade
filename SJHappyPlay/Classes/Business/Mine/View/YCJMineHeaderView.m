

#import "YCJMineHeaderView.h"
#import "SKUserCoinView.h"
#import "YCJNickNameModifyView.h"

@interface YCJMineHeaderView()
///内容视图
@property (nonatomic, strong) UIView            *contentBgView;
/// 头像
@property (nonatomic, strong) UIImageView       *headImageView;
/// 登录注册背景试图
@property (nonatomic, strong) UIView            *loginBgView;
/// 登录注册 / 昵称
@property (nonatomic, strong) UILabel           *nickNameLabel;
@property (nonatomic, strong) UIButton          *modifyBtn;
/// 消息说明
@property (nonatomic, strong) UILabel           *infoLabel;
@property (nonatomic, strong) SKUserCoinView   *userView;

@property (nonatomic, strong) SKUserInfoModel *userInfo;

@end

@implementation YCJMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self reload];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:YCJUserInfoModiyNotification object:nil];
    }
    return self;
}

- (void)reload {
    if ([SKUserInfoManager sharedInstance].userInfoModel) {
        self.userInfo = [SKUserInfoManager sharedInstance].userInfoModel;
        [self.modifyBtn setHidden:NO];
    } else {
        self.nickNameLabel.text = ZCLocalizedString(@"去登录", nil);
        self.headImageView.image = [UIImage imageNamed:@"icon_user_default"];
        self.infoLabel.text = @"";
        [self.modifyBtn setHidden:YES];
    }
}

- (void)setUserInfo:(SKUserInfoModel *)userInfo {
    self.nickNameLabel.text = userInfo.nickname;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    self.infoLabel.text = [NSString stringWithFormat:@"ID: %@", userInfo.memberId];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.headImageView];
    [self.contentBgView addSubview:self.loginBgView];
    [self.loginBgView addSubview:self.nickNameLabel];
    [self.loginBgView addSubview:self.modifyBtn];
    [self.loginBgView addSubview:self.infoLabel];
 
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentBgView);
        make.width.height.mas_equalTo(kSize(70));
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + kSize(20));
    }];
    [self.loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kSize(35));
        make.top.equalTo(self.headImageView.mas_bottom).offset(kSize(6));
        make.centerX.equalTo(self.headImageView);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBgView);
        make.centerX.equalTo(self.headImageView);
    }];
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLabel);
        make.size.mas_equalTo(50);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(5);
        make.right.equalTo(self.loginBgView);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(kSize(4));
        make.left.right.equalTo(self.loginBgView);
    }];

    [self.contentBgView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBgView.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentBgView);
        make.height.mas_equalTo(50);
    }];
    
    UITapGestureRecognizer *headImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap:)];
    [self.headImageView addGestureRecognizer:headImageGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTap:)];
    [self.loginBgView addGestureRecognizer:tapGesture];
    
}

#pragma mark - 点击登录
#pragma mark -- tap
- (void)headImageTap:(UIGestureRecognizer *)gestureRecognizer{
    if (self.mineHeaderViewHeadImageClickBlock) {
        self.mineHeaderViewHeadImageClickBlock();
    }
}
#pragma mark - 点击登录
#pragma mark -- tap
- (void)loginTap:(UIGestureRecognizer *)gestureRecognizer{
    if (self.mineHeaderViewHeadImageClickBlock) {
        self.mineHeaderViewHeadImageClickBlock();
    }
}

- (void)modifyUserNickName {
    YCJNickNameModifyView *modify = [[YCJNickNameModifyView alloc] init];
    modify.commonAlertViewDoneClickBlock = ^{
        
    };
    [modify show];
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIView new];
    }
    return _contentBgView;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.image = [UIImage imageNamed:@"icon_user_default"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = kSize(35);
    }
    return _headImageView;
}

- (UIView *)loginBgView{
    if (!_loginBgView) {
        _loginBgView = [UIView new];
    }
    return _loginBgView;
}
- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.font = kPingFangMediumFont(14);
        _nickNameLabel.textColor = kCommonWhiteColor;
        _nickNameLabel.text = @"";
    }
    return _nickNameLabel;
}

- (UIButton *)modifyBtn {
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc] init];
        [_modifyBtn setImage:[UIImage imageNamed:@"icon_mine_user_xiugai"] forState:UIControlStateNormal];
        _modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_modifyBtn addTarget:self action:@selector(modifyUserNickName) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = kPingFangMediumFont(14);
        _infoLabel.textColor = kCommonWhiteColor;
        _infoLabel.text = @"ID：";
    }
    return _infoLabel;
}

- (SKUserCoinView *)userView {
    if (!_userView) {
        _userView = [[SKUserCoinView alloc] init];
    }
    return _userView;
}

@end
