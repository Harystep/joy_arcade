

#import "YCJRankContentView.h"
#import "YCJRankListModel.h"

@interface YCJRankContentView()
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIImageView   *contentBgView;
/// 头像
@property (nonatomic, strong) UIImageView   *headImgView;
@property (nonatomic, strong) UILabel       *nameLB;
@property (nonatomic, strong) UIImageView   *jifenImgView;
@property (nonatomic, strong) UILabel       *jifenLB;

@end

@implementation YCJRankContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setRankModel:(YCJRankListModel *)rankModel type:(NSInteger)type {
    if (type == 1) {
        self.contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_phb_dashi_en"]];
        self.jifenImgView.image = [UIImage imageNamed:@"icon_phb_jifen"];
    } else {
        self.contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_phb_caifu_en"]];
        self.jifenImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
    }
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:rankModel.avatar]];
    self.nameLB.text = rankModel.nickName;
    self.jifenLB.text = rankModel.total;
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.jifenImgView];
    [self.contentView addSubview:self.jifenLB];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(44);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgView);
        make.left.equalTo(self.headImgView.mas_right).offset(10);
    }];
    
    [self.jifenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.width.height.mas_equalTo(20);
        make.bottom.equalTo(self.headImgView.mas_bottom);
    }];
    
    [self.jifenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jifenImgView);
        make.left.equalTo(self.jifenImgView.mas_right).offset(5);
    }];
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentBgView.image = [UIImage imageNamed:@""];
        _contentBgView.layer.masksToBounds = YES;
    }
    return _contentBgView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headImgView.image = [UIImage imageNamed:@"icon_user_default"];
        _headImgView.cornerRadius = 22;
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
        _nameLB.font = kPingFangMediumFont(14);
        _nameLB.textColor = kCommonWhiteColor;
    }
    return _nameLB;
}

- (UIImageView *)jifenImgView {
    if (!_jifenImgView) {
        _jifenImgView = [UIImageView new];
        _jifenImgView.contentMode = UIViewContentModeScaleAspectFit;
        _jifenImgView.image = [UIImage imageNamed:@""];
    }
    return _jifenImgView;
}

- (UILabel *)jifenLB {
    if (!_jifenLB) {
        _jifenLB = [[UILabel alloc] init];
        _jifenLB.text = @"";
        _jifenLB.textAlignment = NSTextAlignmentLeft;
        _jifenLB.font = kPingFangRegularFont(12);
        _jifenLB.textColor = kCommonWhiteColor;
    }
    return _jifenLB;
}

@end
