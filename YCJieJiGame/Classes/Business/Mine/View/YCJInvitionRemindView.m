//
//  YCJInvitionRemindView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/31.
//

#import "YCJInvitionRemindView.h"
#import "YCJInviteCodeModel.h"

@interface YCJInvitionRemindView ()

@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIView                *line1View;
@property (nonatomic, strong) UIView                *line2View;
@property (nonatomic, strong) UILabel               *titleLB;
@property (nonatomic, strong) UILabel               *contentLB;

@end

@implementation YCJInvitionRemindView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setInviteModel:(YCJInviteCodeModel *)inviteModel {
    NSString *content = [NSString stringWithFormat:@"每邀请一位好友加入并输入您的邀请码，您和被邀请人都将获得%@钻石奖励，每个用户最高可获得%@钻石", inviteModel.rewards, inviteModel.max_rewards];
    NSString *rewards = [NSString stringWithFormat:@"%@钻石奖励", inviteModel.rewards];
    NSString *max_rewards = [NSString stringWithFormat:@"最高可获得%@钻石", inviteModel.max_rewards];
    self.contentLB.attributedText = [content highlights:@[rewards, max_rewards] highlightColor:kColorHex(0x333333)];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.line1View];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.line2View];
    [self.contentView addSubview:self.contentLB];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(20);
    }];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.titleLB);
        make.right.equalTo(self.titleLB.mas_left).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.titleLB);
        make.left.equalTo(self.titleLB.mas_right).offset(20);
        make.height.mas_equalTo(1);
    }];
    
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(-10);
        make.bottom.equalTo(self.contentView);
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

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [UIView new];
        _line1View.backgroundColor = kColorHex(0xB89E81);
    }
    return _line1View;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [UIView new];
        _line2View.backgroundColor = kColorHex(0xB89E81);
    }
    return _line2View;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"邀请奖励";
        _titleLB.textColor = kColorHex(0xB89E81);
        _titleLB.font = kPingFangRegularFont(14);
    }
    return _titleLB;
}

- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.textColor = kColorHex(0xB89E81);
        _contentLB.font = kPingFangRegularFont(14);
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
}

@end
