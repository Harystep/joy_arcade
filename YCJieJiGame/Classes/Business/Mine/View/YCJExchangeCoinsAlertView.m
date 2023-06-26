//
//  YCJExchangeCoinsAlertView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/23.
//

#import "YCJExchangeCoinsAlertView.h"
#import "YCJExchangeModel.h"

@interface YCJExchangeCoinsAlertView()
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UIView        *contentLBbgView;
@property (nonatomic, strong) UILabel       *contentLB;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;
@end

@implementation YCJExchangeCoinsAlertView

- (void)setupSubviews {
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(45));
        make.right.mas_equalTo(-kSize(45));
        make.centerY.equalTo(self);
    }];
    
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.contentLBbgView];
    [self.contentLBbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.height.mas_equalTo(70);
    }];
    
    [self.contentLBbgView addSubview:self.contentLB];
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.contentLBbgView);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.contentLBbgView.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

- (void)setExchangeModel:(YCJExchangeModel *)exchangeModel {
    _exchangeModel = exchangeModel;
    NSString *content = [NSString stringWithFormat:@"确认%@积分兑换%@金币", exchangeModel.points, exchangeModel.goldCoin];
    NSAttributedString *contentAttri = [content highlights:@[[NSString stringWithFormat:@"%@积分", exchangeModel.points], [NSString stringWithFormat:@"%@金币", exchangeModel.goldCoin]] highlightColor:kColorHex(0xCF2F2A)];
    self.contentLB.attributedText = contentAttri;
}

- (void)setZuanshi:(NSString *)zuanshi {
    NSString *content = [NSString stringWithFormat:@"确认%@钻石兑换%d金币", zuanshi, ([zuanshi intValue] * 10)];
    NSAttributedString *contentAttri = [content highlights:@[[NSString stringWithFormat:@"%@钻石", zuanshi], [NSString stringWithFormat:@"%d金币",  ([zuanshi intValue] * 10)]] highlightColor:kColorHex(0xCF2F2A)];
    self.contentLB.attributedText = contentAttri;
}

- (void)show {
    /// 初始化视图
    [self setupSubviews];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];

    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureBtnAction {
    
    if (self.commonAlertViewDoneClickBlock) {
        self.commonAlertViewDoneClickBlock(self, self.exchangeModel);
    }
}



#pragma mark -- lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kCommonWhiteColor;
        _contentView.layer.cornerRadius = 9;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"积分兑换金币";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(15);
        _titleLB.textColor = kCommonBlackColor;
    }
    return _titleLB;
}

- (UIView *)contentLBbgView {
    if (!_contentLBbgView) {
        _contentLBbgView = [[UIView alloc] init];
        _contentLBbgView.backgroundColor = kColorHex(0xFFF4F4);
        _contentLBbgView.cornerRadius = 6;
    }
    return  _contentLBbgView;
}

- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.textAlignment = NSTextAlignmentCenter;
        _contentLB.font = kPingFangMediumFont(16);
        _contentLB.textColor = kCommonBlackColor;
    }
    return _contentLB;
}


- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"返回游戏" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColorHex(0x46599C) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kPingFangRegularFont(14);
        _cancelBtn.backgroundColor = kColorHex(0xEEF2FF);
        _cancelBtn.cornerRadius = kSize(4);
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangRegularFont(14);
        _sureBtn.backgroundColor = kColorHex(0x6984EA);
        _sureBtn.cornerRadius = kSize(4);
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
