//
//  YCJRankSelectedView.m
//  YCJieJiGame
//
//  Created by zza on 2023/6/20.
//

#import "YCJRankSelectedView.h"

@interface YCJRankSelectedView ()
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIButton              *zhichuBtn;
@property (nonatomic, strong) UIButton              *shouruBtn;
@property (nonatomic, strong) UIButton              *currentBtn;

@end

@implementation YCJRankSelectedView


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
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView.mas_centerX).offset(-kMargin);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [self.shouruBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView.mas_centerX).offset(kMargin);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

- (void)consumeTypeAction:(UIButton *)send {
    if (self.currentBtn.tag == send.tag) {
        return;
    } else {
        [self.currentBtn setBackgroundColor:[UIColor clearColor]];
        self.currentBtn.borderColor = kCommonWhiteColor;
        self.currentBtn.borderWidth = 1;
        [send setBackgroundColor:kColorHex(0x6984EA)];
        send.borderColor = [UIColor clearColor];
        send.borderWidth = 0;
    }
    if (self.commonAlertViewDoneClickBlock) {
        self.commonAlertViewDoneClickBlock(send.tag);
    }
    
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
        [_zhichuBtn setTitle:@"大师榜" forState:UIControlStateNormal];
        [_zhichuBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _zhichuBtn.titleLabel.font = kPingFangRegularFont(14);
        [_zhichuBtn addTarget:self action:@selector(consumeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _zhichuBtn.cornerRadius = 8;
        _zhichuBtn.tag = 2;
    }
    return _zhichuBtn;
}

- (UIButton *)shouruBtn {
    if (!_shouruBtn) {
        _shouruBtn = [[UIButton alloc] init];
        [_shouruBtn setBackgroundColor:[UIColor clearColor]];
        _shouruBtn.borderWidth = 1;
        _shouruBtn.borderColor = kCommonWhiteColor;
        [_shouruBtn setTitle:@"财富榜" forState:UIControlStateNormal];
        [_shouruBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _shouruBtn.titleLabel.font = kPingFangRegularFont(14);
        [_shouruBtn addTarget:self action:@selector(consumeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _shouruBtn.cornerRadius = 8;
        _shouruBtn.tag = 1;
    }
    return _shouruBtn;
}

@end
