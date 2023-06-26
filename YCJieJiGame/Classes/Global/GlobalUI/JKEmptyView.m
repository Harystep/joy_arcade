//
//  JKEmptyView.m
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import "JKEmptyView.h"

#import "JKDefaultButton.h"

@interface JKEmptyView()

@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UILabel *textLabel;
@property(nonatomic, weak) UIButton *actionBtn;
@property(nonatomic, strong) UIView *contentBgView;
@property(nonatomic, copy) JKEmptyViewActionBlock actionBlock;

@end

@implementation JKEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.55);
        make.width.mas_equalTo(kSize(105));
        make.height.mas_equalTo(kSize(95));
    }];
    self.imageView = imageView;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.font = kPingFangRegularFont(14);
    textLabel.textColor = kCommonBlackColor;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.left.greaterThanOrEqualTo(self).offset(15);
    }];
    self.textLabel = textLabel;
    
    UIButton *actionBtn = [[UIButton alloc] init];
    [actionBtn setTitleColor:kColorHex(0x9EAAD8) forState:UIControlStateNormal];
    [actionBtn setTitle:@"刷新" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = kPingFangLightFont(14);
    actionBtn.borderColor = kColorHex(0x7986B3);
    actionBtn.borderWidth = 1;
    actionBtn.cornerRadius = 15;
    [actionBtn addTarget:self action:@selector(actionBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionBtn];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(textLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(kSize(80));
        make.height.mas_equalTo(30);
    }];
    self.actionBtn = actionBtn;
    
    UIView *contentBgView = [[UIView alloc] init];
    contentBgView.backgroundColor = kCommonWhiteColor;
    contentBgView.cornerRadius = kSize(12);
    [self insertSubview:contentBgView atIndex:0];
    [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + 15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(actionBtn.mas_bottom).offset(10);
    }];
    self.contentBgView = contentBgView;
}

- (void)setEmptyBgColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
}

- (void)setContentBgViewColor:(UIColor *)backgroundColor {
    self.contentBgView.backgroundColor = backgroundColor;
}

- (void)setupText:(NSString *)text {
    [self setupText:text image:nil];
}

- (void)setupText:(NSString *)text image:(UIImage *)image {
    [self setupText:text image:image actionTitle:nil action:nil];
}

- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setupText:(NSString *)text image:(UIImage *)image actionTitle:(NSString *)actionTitle action:(JKEmptyViewActionBlock)action {
    self.textLabel.text = text;
    self.imageView.image = image;
    [self.actionBtn setTitle:actionTitle forState:UIControlStateNormal];
    self.actionBlock = action;
    self.actionBtn.hidden = action == nil;
}


- (void)actionBtnDidClick {
    if(self.actionBlock) self.actionBlock();
}


@end
