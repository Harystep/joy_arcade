//
//  YCJRankBottomView.m
//  YCJieJiGame
//
//  Created by zza on 2023/5/24.
//

#import "YCJRankBottomView.h"
#import "YCJRankListModel.h"

@interface YCJRankBottomView()
///内容视图
@property (nonatomic, strong) UIView        *contentBgView;
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *rankLB;
@property (nonatomic, strong) YCJUserInfoModel *userInfo;
/// 头像
@property (nonatomic, strong) UIImageView   *headImgView;
@property (nonatomic, strong) UILabel       *nameLB;
@property (nonatomic, strong) UILabel       *jifenLB;

@end

@implementation YCJRankBottomView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setUserInfo:(YCJUserInfoModel *)userInfo {
    self.nameLB.text = userInfo.nickname;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    self.jifenLB.text = userInfo.points;
}

- (void)setMyRank:(YCJRankListModel *)myRank {
    if (myRank) {
        self.nameLB.text = myRank.nickName;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:myRank.avatar]];
        self.jifenLB.text = myRank.total;
        if (myRank.hasRank == 1) {
            self.rankLB.text = myRank.rank;
        } else {
            self.rankLB.text = @"未上榜";
        }
    } else {
        self.nameLB.text = @"去登录";
        self.headImgView.image = [UIImage imageNamed:@"icon_user_default"];
        self.jifenLB.text = @"0";
    }
}

- (void)goLoginAction {
    if ([[YCJUserInfoManager sharedInstance] isLogin:self.parentController]) {
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentBgView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.bottom.mas_equalTo(-10);
    }];
    [self.contentView addSubview:self.rankLB];
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.jifenLB];
    
    [self.rankLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(20);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(36);
        make.left.equalTo(self.rankLB.mas_right).offset(10);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.headImgView.mas_right).offset(10);
    }];
    
    [self.jifenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-40);
    }];
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [UIView new];
        _contentBgView.backgroundColor = kColorHex(0x1E439B);
    }
    return _contentBgView;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = kColorHex(0x669CFF);
        _contentView.cornerRadius = kSize(12);
    }
    return _contentView;
}

- (UILabel *)rankLB {
    if (!_rankLB) {
        _rankLB = [[UILabel alloc] init];
        _rankLB.text = @"未上榜";
        _rankLB.textAlignment = NSTextAlignmentLeft;
        _rankLB.font = kPingFangRegularFont(14);
        _rankLB.textColor = kCommonWhiteColor;
    }
    return _rankLB;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headImgView.image = [UIImage imageNamed:@""];
        _headImgView.cornerRadius = 18;
        _headImgView.borderColor = kCommonWhiteColor;
        _headImgView.borderWidth = 2;
    }
    return _headImgView;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.text = @"";
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.font = kPingFangRegularFont(14);
        _nameLB.textColor = kCommonWhiteColor;
        _nameLB.userInteractionEnabled = YES;
        [_nameLB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLoginAction)]];
    }
    return _nameLB;
}

- (UILabel *)jifenLB {
    if (!_jifenLB) {
        _jifenLB = [[UILabel alloc] init];
        _jifenLB.text = @"";
        _jifenLB.textAlignment = NSTextAlignmentLeft;
        _jifenLB.font = kPingFangSemiboldFont(18);
        _jifenLB.textColor = kCommonWhiteColor;
    }
    return _jifenLB;
}

@end
