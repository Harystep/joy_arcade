//
//  YCJConsumeTypeView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/6/13.
//

#import "YCJConsumeTypeView.h"
#import "YCJConsumeModel.h"

@interface YCJConsumeTypeView ()
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIButton              *zhichuBtn;
@property (nonatomic, strong) UIButton              *shouruBtn;
@property (nonatomic, strong) UIButton              *currentBtn;
@end

@implementation YCJConsumeTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.currentBtn = self.zhichuBtn;
    }
    return self;
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.zhichuBtn];
    [self.contentView addSubview:self.shouruBtn];
    [self.zhichuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView.mas_centerX).offset(-kMargin);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [self.shouruBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView.mas_centerX).offset(kMargin);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

- (void)consumeTypeAction:(UIButton *)send {
    if (self.currentBtn.tag == send.tag) {
        return;
    } else {
        [self.currentBtn setTitleColor:kColorHex(0x666666) forState:UIControlStateNormal];
        [self.currentBtn setBackgroundColor:kCommonWhiteColor];
        [send setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [send setBackgroundColor:kColorHex(0x6984EA)];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:YCJConsumeTypeModiyNotification object:[NSString stringWithFormat:@"%ld", send.tag]];
    self.currentBtn = send;
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIButton *)zhichuBtn {
    if (!_zhichuBtn) {
        _zhichuBtn = [[UIButton alloc] init];
        [_zhichuBtn setBackgroundColor:kColorHex(0x6984EA)];
        [_zhichuBtn setTitle:@"支出" forState:UIControlStateNormal];
        [_zhichuBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _zhichuBtn.titleLabel.font = kPingFangRegularFont(14);
        [_zhichuBtn addTarget:self action:@selector(consumeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _zhichuBtn.cornerRadius = 15;
        _zhichuBtn.tag = 2;
    }
    return _zhichuBtn;
}

- (UIButton *)shouruBtn {
    if (!_shouruBtn) {
        _shouruBtn = [[UIButton alloc] init];
        [_shouruBtn setBackgroundColor:kCommonWhiteColor];
        [_shouruBtn setTitle:@"收入" forState:UIControlStateNormal];
        [_shouruBtn setTitleColor:kColorHex(0x666666) forState:UIControlStateNormal];
        _shouruBtn.titleLabel.font = kPingFangRegularFont(14);
        [_shouruBtn addTarget:self action:@selector(consumeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _shouruBtn.cornerRadius = 15;
        _shouruBtn.tag = 1;
    }
    return _shouruBtn;
}

@end
