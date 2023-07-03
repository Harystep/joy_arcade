

#import "QAExchangeSuccessAlertView.h"

@interface QAExchangeSuccessAlertView()

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIImageView   *contentBgView;

@end

@implementation QAExchangeSuccessAlertView

- (void)setupSubviews {

    
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(230);
    }];
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
    
    kRunAfter(2, ^{
        [self dismiss];
    });
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
        self.commonAlertViewDoneClickBlock();
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

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleAspectFit;
        _contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_exchange_dhcg"]];
    }
    return _contentBgView;
}


@end
