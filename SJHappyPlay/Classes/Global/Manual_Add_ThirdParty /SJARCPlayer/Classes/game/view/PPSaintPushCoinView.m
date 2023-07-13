#import "PPSaintPushCoinView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "POP.h"

#import "AppDefineHeader.h"

@interface PPSaintPushCoinView ()
@property (nonatomic, weak) UIButton * pushCoin5Button;
@property (nonatomic, weak) UIButton * pushCoin10Button;
@property (nonatomic, weak) UIButton * pushCoint20Button;
@end
@implementation PPSaintPushCoinView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView {
    [self pushCoin5Button];
    [self pushCoin10Button];
    [self pushCoint20Button];
}
- (void)onPushCoinTapPress:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        [self.pushCoinDelegate pushCoinWithCoinCount:5];
    } else if (tag == 2) {
        [self.pushCoinDelegate pushCoinWithCoinCount:10];
    } else if (tag == 3) {
        [self.pushCoinDelegate pushCoinWithCoinCount:20];
    }
    [self onTapEndCoinButton:sender];
}
- (void)onTapBeginCoinButton:(UIButton *)sender {
    POPBasicAnimation * bigAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    bigAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
    bigAnimation.duration = 0.3;
    [sender pop_addAnimation:bigAnimation forKey:@"big_anim"];
}
- (void)onTapEndCoinButton:(UIButton *)sender {
    POPBasicAnimation * smailAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    smailAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    smailAnimation.duration = 0.3;
    [sender pop_addAnimation:smailAnimation forKey:@"smail_anim"];
}
- (void)showButtons {
    [self setHidden:false];
    POPBasicAnimation * showAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation1.fromValue = @(0);
    showAnimation1.toValue = @(1);
    showAnimation1.duration = 0.3;
    [self.pushCoin5Button pop_addAnimation:showAnimation1 forKey:@"show_1"];
    POPBasicAnimation * showAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation2.fromValue = @(0);
    showAnimation2.toValue = @(1);
    showAnimation2.duration = 0.3;
    showAnimation2.beginTime = 0.3;
    [self.pushCoin10Button pop_addAnimation:showAnimation2 forKey:@"show_2"];
    POPBasicAnimation * showAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation3.fromValue = @(0);
    showAnimation3.toValue = @(1);
    showAnimation3.duration = 0.3;
    showAnimation3.beginTime = 0.6;
    [self.pushCoint20Button pop_addAnimation:showAnimation3 forKey:@"show_3"];
}
- (void)hideButtons {
    POPBasicAnimation * hideAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnimation1.fromValue = @(1);
    hideAnimation1.toValue = @(0);
    hideAnimation1.duration = 0.3;
    [self.pushCoin5Button pop_addAnimation:hideAnimation1 forKey:@"hide_1"];
    POPBasicAnimation * hideAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnimation2.fromValue = @(1);
    hideAnimation2.toValue = @(0);
    hideAnimation2.duration = 0.3;
    hideAnimation2.beginTime = 0.3;
    [self.pushCoin10Button pop_addAnimation:hideAnimation2 forKey:@"hide_2"];
    POPBasicAnimation * hideAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnimation3.fromValue = @(1);
    hideAnimation3.toValue = @(0);
    hideAnimation3.duration = 0.3;
    hideAnimation3.beginTime = 0.6;
    [self.pushCoint20Button pop_addAnimation:hideAnimation3 forKey:@"hide_3"];
}
#pragma mark - lazy
- (UIButton *)pushCoin5Button{
    if (!_pushCoin5Button) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(80));
            make.top.equalTo(self).offset(DSize(20));
            make.centerX.equalTo(self);
        }];
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = DSize(38);
        [theView setTitle:@"+20" forState:UIControlStateNormal];
        theView.titleLabel.font = [UIFont systemFontOfSize:14];
        theView.layer.borderWidth = 1;
        theView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        theView.tag = 3;
        theView.alpha = 0;
        [theView addTarget:self action:@selector(onPushCoinTapPress:) forControlEvents:UIControlEventTouchUpInside];
        [theView addTarget:self action:@selector(onTapBeginCoinButton:) forControlEvents:UIControlEventTouchDown];
        _pushCoin5Button = theView;
    }
    return _pushCoin5Button;
}
- (UIButton *)pushCoin10Button{
    if (!_pushCoin10Button) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(80));
            make.top.equalTo(self.pushCoin5Button.mas_bottom).offset(DSize(20));
            make.centerX.equalTo(self);
        }];
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = DSize(38);
        [theView setTitle:@"+10" forState:UIControlStateNormal];
        theView.titleLabel.font = [UIFont systemFontOfSize:14];
        theView.layer.borderWidth = 1;
        theView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        theView.tag = 2;
        theView.alpha = 0;
        [theView addTarget:self action:@selector(onPushCoinTapPress:) forControlEvents:UIControlEventTouchUpInside];
        [theView addTarget:self action:@selector(onTapBeginCoinButton:) forControlEvents:UIControlEventTouchDown];
        _pushCoin10Button = theView;
    }
    return _pushCoin10Button;
}
- (UIButton *)pushCoint20Button{
    if (!_pushCoint20Button) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(80));
            make.height.mas_equalTo(DSize(80));
            make.top.equalTo(self.pushCoin10Button.mas_bottom).offset(DSize(20));
            make.centerX.equalTo(self);
        }];
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = DSize(38);
        [theView setTitle:@"+5" forState:UIControlStateNormal];
        theView.titleLabel.font = [UIFont systemFontOfSize:14];
        theView.layer.borderWidth = 1;
        theView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        theView.tag = 1;
        theView.alpha = 0;
        [theView addTarget:self action:@selector(onPushCoinTapPress:) forControlEvents:UIControlEventTouchUpInside];
        [theView addTarget:self action:@selector(onTapBeginCoinButton:) forControlEvents:UIControlEventTouchDown];
        _pushCoint20Button = theView;
    }
    return _pushCoint20Button;
}
@end
