

#import "YCJHomeUserView.h"
#import "SKUserCoinView.h"
#import "KMVIPProcessView.h"

@interface YCJHomeUserView ()

@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) SKUserCoinView       *userCoinView;
@property (nonatomic, strong) SKUserInfoModel      *userInfo;
/// 头像
@property (nonatomic, strong) UIImageView           *headImgView;
@property (nonatomic, strong) UILabel               *nameLB;
@property (nonatomic, strong) KMVIPProcessView     *processView;

@end

@implementation YCJHomeUserView

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
    } else {
        self.nameLB.text = ZCLocalizedString(@"去登录", nil);
        self.headImgView.image = [UIImage imageNamed:@"icon_user_default"];
    }
}

- (void)setUserInfo:(SKUserInfoModel *)userInfo {
    self.nameLB.text = userInfo.nickname;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.userCoinView];
    [self.contentView addSubview:self.processView];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.height.width.mas_equalTo(kSize(60));
        make.top.mas_equalTo(kMargin);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSize(60));
        make.top.equalTo(self.headImgView.mas_bottom).offset(kMargin);
        make.centerX.equalTo(self.headImgView);
    }];
    
    [self.userCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImgView);
        make.left.equalTo(self.headImgView.mas_right);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLB);
        make.left.equalTo(self.userCoinView).offset(15);
        make.width.mas_equalTo(kSize(180));
        make.height.mas_equalTo(kSize(14));
    }];
    
    UITapGestureRecognizer *headImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTap:)];
    [self.headImgView addGestureRecognizer:headImageGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTap:)];
    [self.nameLB addGestureRecognizer:tapGesture];
}

#pragma mark - 点击登录
#pragma mark -- tap
- (void)loginTap:(UIGestureRecognizer *)gestureRecognizer{
    if ([[SKUserInfoManager sharedInstance] isLogin: self.parentController]) {}
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headImgView.image = [UIImage imageNamed:@"icon_user_default"];
        _headImgView.cornerRadius = kSize(30);
        _headImgView.borderColor = kCommonWhiteColor;
        _headImgView.borderWidth = 2;
        _headImgView.userInteractionEnabled = YES;
    }
    return _headImgView;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.text = @"";
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.font = kPingFangMediumFont(14);
        _nameLB.textColor = kCommonWhiteColor;
        _nameLB.userInteractionEnabled = YES;
    }
    return _nameLB;
}

- (SKUserCoinView *)userCoinView {
    if (!_userCoinView) {
        _userCoinView = [[SKUserCoinView alloc] init];
    }
    return _userCoinView;
}

- (KMVIPProcessView *)processView {
    if (!_processView) {
        _processView = [[KMVIPProcessView alloc] initWithFrame:CGRectMake(0, 0, kSize(180), kSize(14))];
    }
    return _processView;
}
@end
