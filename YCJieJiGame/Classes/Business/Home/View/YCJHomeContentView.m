//
//  YCJHomeContentView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/29.
//

#import "YCJHomeContentView.h"
#import "YCJGameRoomModel.h"
#import "YCJGameRoomViewController.h"

@interface YCJHomeContentView()
@property (nonatomic, strong) NSMutableArray    *gcolors;
@property (nonatomic, strong) UIView            *contentView;
@property (nonatomic, strong) UIImageView       *contentImgView;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) UILabel           *titleLB;

@end
#define GameButtonHeight 70
@implementation YCJHomeContentView

- (NSMutableArray *)gcolors {
    if (!_gcolors) {
        _gcolors = [NSMutableArray array];
        [_gcolors addObject:@[(id)kColorHex(0xFBE593).CGColor,(id)kColorHex(0xE79357).CGColor]];
        [_gcolors addObject:@[(id)kColorHex(0xFEAB89).CGColor,(id)kColorHex(0xED7B5A).CGColor]];
        [_gcolors addObject:@[(id)kColorHex(0xF6AFDF).CGColor,(id)kColorHex(0xED5A7A).CGColor]];
        [_gcolors addObject:@[(id)kColorHex(0xAC99ED).CGColor,(id)kColorHex(0xD35AED).CGColor]];
    }
    return _gcolors;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer.frame = self.bounds;
        [self configUI];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    NSInteger tag = index % 4;
    self.gradientLayer.colors = self.gcolors[tag];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)setGameRoomModel:(YCJGameRoomModel *)gameRoomModel {
    _gameRoomModel = gameRoomModel;
    
    [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:gameRoomModel.thumb]];
    [self.contentView addSubview:self.contentImgView];
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(220);
    }];
    
    self.titleLB.text = gameRoomModel.name;
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];

    for (int i = 0; i < gameRoomModel.roomGroupList.count; i++) {
        YCJGameRoomGroup *group = gameRoomModel.roomGroupList[i];
        UIButton *roomBtn = [[UIButton alloc] init];
        roomBtn.frame = CGRectMake(12, 295 + (GameButtonHeight + 10) * i, self.frame.size.width - 24, GameButtonHeight);
        roomBtn.tag = i;
        [roomBtn addTarget:self action:@selector(roomAction:) forControlEvents:UIControlEventTouchUpInside];
        [roomBtn setBackgroundImage:[UIImage imageNamed:@"icon_home_game_arrow"] forState:UIControlStateNormal];
        UILabel *roomNameLb = [[UILabel alloc] init];
        roomNameLb.text = group.groupName;
        roomNameLb.textColor = kColorHex(0x86552F);
        roomNameLb.font = kPingFangSemiboldFont(18);
        [roomBtn addSubview:roomNameLb];
        [roomNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(30);
        }];
        UILabel *vipLB = [[UILabel alloc] init];
        vipLB.text = @"V0-V4";
        vipLB.textColor = kColorHex(0xC9964D);
        vipLB.font = kPingFangRegularFont(12);
        [roomBtn addSubview:vipLB];
        [vipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.equalTo(roomNameLb.mas_bottom).offset(5);
        }];
        [self.contentView addSubview:roomBtn];
    }
}

- (void)roomAction:(UIButton *)send {
    if ([[YCJUserInfoManager sharedInstance] isLogin:self.parentController]) {
        YCJGameRoomGroup *group = self.gameRoomModel.roomGroupList[send.tag];
        YCJGameRoomViewController *vc = [[YCJGameRoomViewController alloc] init];
        vc.titleStr = self.gameRoomModel.name;
        vc.roomGroup = group;
        [self.parentController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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

- (UIImageView *)contentImgView {
    if (!_contentImgView) {
        _contentImgView = [UIImageView new];
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.cornerRadius = kSize(6);
    }
    return _contentImgView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(26);
        _titleLB.textColor = kColorHex(0x86552F);
    }
    return _titleLB;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradientLayer;
}
@end
