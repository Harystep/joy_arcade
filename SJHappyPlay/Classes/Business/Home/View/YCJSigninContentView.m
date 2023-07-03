

#import "YCJSigninContentView.h"
#import "YCJSignInListModel.h"

@interface YCJSigninContentView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIView        *topView;
@property (nonatomic, strong) UIImageView   *jifenImgView;
@property (nonatomic, strong) UILabel       *jifenLB;
@property (nonatomic, strong) UILabel       *dayLB;
@property (nonatomic, strong) UIView        *signInView;
@property (nonatomic, strong) UIImageView   *duigImgView;
@property (nonatomic, strong) UILabel       *signInLB;
@end

@implementation YCJSigninContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setDetailModel:(YCJSignInDetailModel *)detailModel {
    
    self.dayLB.text = detailModel.desc;
    self.jifenLB.text = [NSString stringWithFormat:@"X %@", detailModel.points];
    if ([detailModel.status isEqualToString:@"1"]) {
        self.signInView.hidden = YES;
    } else {
        self.signInView.hidden = NO;
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self addSubview:self.signInView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.signInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.signInView addSubview:self.duigImgView];
    [self.signInView addSubview:self.signInLB];
    [self.duigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.signInView);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.signInView).offset(-10);
    }];
    [self.signInLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.signInView);
        make.centerY.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(65);
        make.top.mas_equalTo(8);
    }];
    
    [self.contentView addSubview:self.dayLB];
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
    [self.topView addSubview:self.jifenImgView];
    [self.topView addSubview:self.jifenLB];
    [self.jifenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.topView).offset(-10);
    }];
    
    [self.jifenLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(20);
    }];
    
    
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithPatternImage:[UIView gradient:[NSArray arrayWithObjects:(id)kColorHex(0xDDE4FF).CGColor,(id)kColorHex(0xA9C2FF).CGColor,nil] size:CGSizeMake(80, 100)]];
        _contentView.borderWidth = 1;
        _contentView.cornerRadius = 6;
        _contentView.borderColor = kCommonWhiteColor;
    }
    return _contentView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor colorWithPatternImage:[UIView gradient:[NSArray arrayWithObjects:(id)kColorHex(0xA6B5FF).CGColor,(id)kColorHex(0x5279CE).CGColor,nil] size:CGSizeMake(65, 65)]];
        _topView.cornerRadius = 6;
    }
    return _topView;
}

- (UIImageView *)jifenImgView {
    if (!_jifenImgView) {
        _jifenImgView = [UIImageView new];
        _jifenImgView.contentMode = UIViewContentModeScaleAspectFit;
        _jifenImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
    }
    return _jifenImgView;
}

- (UILabel *)jifenLB {
    if (!_jifenLB) {
        _jifenLB = [[UILabel alloc] init];
        _jifenLB.text = @"";
        _jifenLB.textAlignment = NSTextAlignmentLeft;
        _jifenLB.font = kPingFangSemiboldFont(16);
        _jifenLB.textColor = kCommonWhiteColor;
    }
    return _jifenLB;
}

- (UILabel *)dayLB {
    if (!_dayLB) {
        _dayLB = [[UILabel alloc] init];
        _dayLB.text = @"";
        _dayLB.textAlignment = NSTextAlignmentLeft;
        _dayLB.font = kPingFangRegularFont(14);
        _dayLB.textColor = kColorHex(0x173166);
    }
    return _dayLB;
}

- (UIView *)signInView {
    if (!_signInView) {
        _signInView = [UIView new];
        _signInView.backgroundColor = kColorHex(0x46599C);
        _signInView.cornerRadius = 6;
        _signInView.alpha = 0.7;
    }
    return _signInView;
}

- (UIImageView *)duigImgView {
    if (!_duigImgView) {
        _duigImgView = [UIImageView new];
        _duigImgView.contentMode = UIViewContentModeScaleAspectFit;
        _duigImgView.image = [UIImage imageNamed:@"icon_home_signin_success"];
    }
    return _duigImgView;
}

- (UILabel *)signInLB {
    if (!_signInLB) {
        _signInLB = [[UILabel alloc] init];
        _signInLB.text = @"";
        _signInLB.textAlignment = NSTextAlignmentLeft;
        _signInLB.font = kPingFangRegularFont(14);
        _signInLB.textColor = kCommonWhiteColor;
    }
    return _signInLB;
}
@end
