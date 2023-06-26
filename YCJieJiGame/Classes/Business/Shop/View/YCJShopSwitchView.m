//
//  YCJShopSwitchView.m
//  YCJieJiGame
//
//  Created by John on 2023/5/31.
//

#import "YCJShopSwitchView.h"
#import "GradientButton.h"

@interface YCJShopSwitchView ()
@property (nonatomic, strong) GradientButton        *jinbiBtn;
@property (nonatomic, strong) GradientButton        *zuansBtn;
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIImageView           *divideBgView;
@property (nonatomic, strong) GradientButton        *currentBtn;

@end

@implementation YCJShopSwitchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)switchAction:(GradientButton *)send {
    if (send == self.currentBtn) return;
    
    if (send.tag == 1) {
        [self.jinbiBtn setNormalBgColorWithColor:kColorHex(0xB4C1EC)];
        [self.zuansBtn setGradientBgColor];
        self.jinbiBtn.selected = NO;
        self.zuansBtn.selected = YES;
    } else {
        [self.jinbiBtn setGradientBgColor];
        [self.zuansBtn setNormalBgColorWithColor:kColorHex(0xB4C1EC)];
        self.jinbiBtn.selected = YES;
        self.zuansBtn.selected = NO;
    }
    
    if (self.switchClickBlock) {
        self.switchClickBlock(send.tag);
    }
    self.currentBtn = send;
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.divideBgView];
    [self.divideBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(30);
    }];
    
    [self.contentView addSubview:self.jinbiBtn];
    [self.contentView addSubview:self.zuansBtn];
    [self.jinbiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self.zuansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.contentView.mas_centerX);
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

- (UIImageView *)divideBgView {
    if (!_divideBgView) {
        _divideBgView = [[UIImageView alloc] init];
        _divideBgView.contentMode = UIViewContentModeScaleAspectFill;
        _divideBgView.image = [UIImage imageNamed:@"icon_shop_divide"];
    }
    return _divideBgView;
}

- (GradientButton *)jinbiBtn {
    if (!_jinbiBtn) {
        _jinbiBtn = [[GradientButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 40)];
        [_jinbiBtn setTitle:[NSString stringWithFormat:@"  %@", ZCLocalizedString(@"金币", nil)] forState:UIControlStateNormal];
        [_jinbiBtn setTitleColor:kColorHex(0x364780) forState:UIControlStateNormal];
        [_jinbiBtn setTitleColor:kColorHex(0x4F3E0B) forState:UIControlStateSelected];
        _jinbiBtn.titleLabel.font = kPingFangMediumFont(18);
        [_jinbiBtn setImage:[UIImage imageNamed:@"icon_shop_jifen_nor"] forState:UIControlStateNormal];
        [_jinbiBtn setImage:[UIImage imageNamed:@"icon_shop_jifen_sel"] forState:UIControlStateSelected];
        [_jinbiBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        _jinbiBtn.selected = YES;
        _jinbiBtn.tag = 2;
        _currentBtn = _jinbiBtn;
    }
    return _jinbiBtn;
}

- (GradientButton *)zuansBtn {
    if (!_zuansBtn) {
        _zuansBtn = [[GradientButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 40)];
        [_zuansBtn setTitle:[NSString stringWithFormat:@"  %@", ZCLocalizedString(@"钻石", nil)] forState:UIControlStateNormal];
        [_zuansBtn setNormalBgColorWithColor:kColorHex(0xB4C1EC)];
        [_zuansBtn setTitleColor:kColorHex(0x364780) forState:UIControlStateNormal];
        [_zuansBtn setTitleColor:kColorHex(0x4F3E0B) forState:UIControlStateSelected];
        _zuansBtn.titleLabel.font = kPingFangMediumFont(18);
        [_zuansBtn setImage:[UIImage imageNamed:@"icon_shop_zs_nor"] forState:UIControlStateNormal];
        [_zuansBtn setImage:[UIImage imageNamed:@"icon_shop_zs_sel"] forState:UIControlStateSelected];
        [_zuansBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        _zuansBtn.tag = 1;
    }
    return _zuansBtn;
}

@end
