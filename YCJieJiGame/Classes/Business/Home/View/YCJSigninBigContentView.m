//
//  YCJSigninBigContentView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/1.
//

#import "YCJSigninBigContentView.h"
#import "YCJSignInListModel.h"

@interface YCJSigninBigContentView ()
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIView        *topView;
@property (nonatomic, strong) UILabel       *dayLB;
@property (nonatomic, strong) UIImageView   *jbImgView;
@property (nonatomic, strong) UILabel       *jbLB;
@property (nonatomic, strong) UIImageView   *zsImgView;
@property (nonatomic, strong) UILabel       *zsLB;
@property (nonatomic, strong) UIImageView   *jfImgView;
@property (nonatomic, strong) UILabel       *jfLB;
@property (nonatomic, strong) UIView        *signInView;
@property (nonatomic, strong) UIImageView   *duigImgView;
@property (nonatomic, strong) UILabel       *signInLB;
@end

@implementation YCJSigninBigContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setDetailModel:(YCJSignInDetailModel *)detailModel {
    
    self.dayLB.text = detailModel.desc;
    self.jbLB.text = [NSString stringWithFormat:@"X %@", detailModel.points];
    self.jfLB.text = [NSString stringWithFormat:@"X %@", detailModel.points];
    self.zsLB.text = [NSString stringWithFormat:@"X %@", detailModel.points];
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
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(65);
    }];
    
    [self.contentView addSubview:self.dayLB];
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
    [self.topView addSubview:self.jbImgView];
    [self.topView addSubview:self.jbLB];
    [self.jbLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView).offset(15);
        make.centerY.equalTo(self.topView);
        make.height.mas_equalTo(20);
    }];
    
    [self.jbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.jbLB.mas_left).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    
    
    [self.topView addSubview:self.zsImgView];
    [self.topView addSubview:self.zsLB];
    [self.zsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView).multipliedBy(0.33);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.topView).offset(-10);
    }];
    
    [self.zsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView).multipliedBy(0.33);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(20);
    }];
    
    [self.topView addSubview:self.jfImgView];
    [self.topView addSubview:self.jfLB];
    [self.jfImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView).multipliedBy(1.66);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.topView).offset(-10);
    }];
    
    [self.jfLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView).multipliedBy(1.66);
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

- (UIImageView *)jbImgView {
    if (!_jbImgView) {
        _jbImgView = [UIImageView new];
        _jbImgView.contentMode = UIViewContentModeScaleAspectFit;
        _jbImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
    }
    return _jbImgView;
}

- (UILabel *)jbLB {
    if (!_jbLB) {
        _jbLB = [[UILabel alloc] init];
        _jbLB.text = @"";
        _jbLB.textAlignment = NSTextAlignmentLeft;
        _jbLB.font = kPingFangSemiboldFont(16);
        _jbLB.textColor = kCommonWhiteColor;
    }
    return _jbLB;
}

- (UIImageView *)zsImgView {
    if (!_zsImgView) {
        _zsImgView = [UIImageView new];
        _zsImgView.contentMode = UIViewContentModeScaleAspectFit;
        _zsImgView.image = [UIImage imageNamed:@"icon_shop_zs"];
        _zsImgView.hidden = YES;
    }
    return _zsImgView;
}

- (UILabel *)zsLB {
    if (!_zsLB) {
        _zsLB = [[UILabel alloc] init];
        _zsLB.text = @"";
        _zsLB.textAlignment = NSTextAlignmentLeft;
        _zsLB.font = kPingFangSemiboldFont(16);
        _zsLB.textColor = kCommonWhiteColor;
        _zsLB.hidden = YES;
    }
    return _zsLB;
}

- (UIImageView *)jfImgView {
    if (!_jfImgView) {
        _jfImgView = [UIImageView new];
        _jfImgView.contentMode = UIViewContentModeScaleAspectFit;
        _jfImgView.image = [UIImage imageNamed:@"icon_phb_jifen"];
        _jfImgView.hidden = YES;
    }
    return _jfImgView;
}

- (UILabel *)jfLB {
    if (!_jfLB) {
        _jfLB = [[UILabel alloc] init];
        _jfLB.text = @"";
        _jfLB.textAlignment = NSTextAlignmentLeft;
        _jfLB.font = kPingFangSemiboldFont(16);
        _jfLB.textColor = kCommonWhiteColor;
        _jfLB.hidden = YES;
    }
    return _jfLB;
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
        _signInLB.text = @"已签到";
        _signInLB.textAlignment = NSTextAlignmentLeft;
        _signInLB.font = kPingFangRegularFont(14);
        _signInLB.textColor = kCommonWhiteColor;
    }
    return _signInLB;
}

@end
