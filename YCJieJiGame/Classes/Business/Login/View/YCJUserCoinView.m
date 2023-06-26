//
//  YCJUserCoinView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/23.
//

#import "YCJUserCoinView.h"

@interface YCJUserCoinView()
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIView        *jbView;
@property (nonatomic, strong) UILabel       *jbLabel;
@property (nonatomic, strong) UIView        *zsView;
@property (nonatomic, strong) UILabel       *zsLabel;
@property (nonatomic, strong) UIView        *jitView;
@property (nonatomic, strong) UILabel       *jitLabel;

@property (nonatomic, strong) YCJUserInfoModel *userInfo;

@end

@implementation YCJUserCoinView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self reload];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:YCJUserInfoModiyNotification object:nil];
    }
    return self;
}

- (void)reload {
    if ([YCJUserInfoManager sharedInstance].userInfoModel) {
        self.userInfo = [YCJUserInfoManager sharedInstance].userInfoModel;
    } else {
        self.jbLabel.text = @"0";
        self.jitLabel.text = @"0";
        self.zsLabel.text = @"0";
    }
}

- (void)setUserInfo:(YCJUserInfoModel *)userInfo {
    self.jbLabel.text = userInfo.goldCoin;
    self.jitLabel.text = userInfo.points;
    self.zsLabel.text = userInfo.money;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = (self.frame.size.width - 20 - 40) / 3;
    [self.zsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)setupViews {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self layoutIfNeeded];
    
    [self.contentView addSubview:self.zsView];
    [self.zsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kSize(100));
        make.height.mas_equalTo(50);
    }];
    [self.zsView addSubview:self.zsLabel];
    [self.zsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zsView);
        make.right.equalTo(self.zsView.mas_right).offset(-15);
        make.left.equalTo(self.zsView.mas_left).offset(30);
    }];
    
    [self.contentView addSubview:self.jbView];
    [self.jbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zsView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(self.zsView);
        make.height.mas_equalTo(50);
    }];
    [self.jbView addSubview:self.jbLabel];
    [self.jbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jbView);
        make.right.equalTo(self.jbView.mas_right).offset(-15);
        make.left.equalTo(self.jbView.mas_left).offset(30);
    }];
    
    [self.contentView addSubview:self.jitView];
    [self.jitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zsView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(self.zsView);
        make.height.mas_equalTo(50);
    }];
    [self.jitView addSubview:self.jitLabel];
    [self.jitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jitView);
        make.right.equalTo(self.jitView.mas_right).offset(-15);
        make.left.equalTo(self.jitView.mas_left).offset(30);
    }];
    
}

#pragma mark -- lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.layer.cornerRadius = 9;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)jbView {
    if (!_jbView) {
        _jbView = [[UIView alloc] init];
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_jb"]];
        bgImg.contentMode = UIViewContentModeScaleAspectFit;
        [_jbView addSubview:bgImg];
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_jbView);
        }];
    }
    return _jbView;
}

- (UILabel *)jbLabel {
    if (!_jbLabel) {
        _jbLabel = [[UILabel alloc] init];
        _jbLabel.textAlignment = NSTextAlignmentCenter;
        _jbLabel.textColor = kCommonWhiteColor;
        _jbLabel.font = kPingFangSemiboldFont(14);
        _jbLabel.adjustsFontSizeToFitWidth = YES;
        _jbLabel.minimumScaleFactor = 0.5;
        _jbLabel.text = @"0";
    }
    return _jbLabel;
}

- (UIView *)zsView {
    if (!_zsView) {
        _zsView = [[UIView alloc] init];
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_zs"]];
        bgImg.contentMode = UIViewContentModeScaleAspectFit;
        [_zsView addSubview:bgImg];
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_zsView);
        }];
    }
    return _zsView;
}

- (UILabel *)zsLabel {
    if (!_zsLabel) {
        _zsLabel = [[UILabel alloc] init];
        _zsLabel.textAlignment = NSTextAlignmentCenter;
        _zsLabel.textColor = kCommonWhiteColor;
        _zsLabel.font = kPingFangSemiboldFont(14);
        _zsLabel.text = @"0";
        _zsLabel.adjustsFontSizeToFitWidth = YES;
        _zsLabel.minimumScaleFactor = 0.5;
    }
    return _zsLabel;
}

- (UIView *)jitView {
    if (!_jitView) {
        _jitView = [[UIView alloc] init];
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_jif"]];
        bgImg.contentMode = UIViewContentModeScaleAspectFit;
        [_jitView addSubview:bgImg];
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_jitView);
        }];
    }
    return _jitView;
}

- (UILabel *)jitLabel {
    if (!_jitLabel) {
        _jitLabel = [[UILabel alloc] init];
        _jitLabel.textAlignment = NSTextAlignmentCenter;
        _jitLabel.textColor = kCommonWhiteColor;
        _jitLabel.font = kPingFangSemiboldFont(14);
        _jitLabel.text = @"0";
        _jitLabel.adjustsFontSizeToFitWidth = YES;
        _jitLabel.minimumScaleFactor = 0.5;
    }
    return _jitLabel;
}

@end
