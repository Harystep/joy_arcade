//
//  YCJGameRoomCell.m
//  YCJieJiGame
//
//  Created by John on 2023/6/5.
//

#import "YCJGameRoomCell.h"
#import "YCJRoomListModel.h"

@interface YCJGameRoomCell ()
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) UIImageView   *coinImgView;
@property (nonatomic, strong) UILabel       *coinLB;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UIImageView   *titleBgView;

@property (nonatomic, strong) UIImageView   *statuImgView;
@property (nonatomic, strong) UIImageView   *vipImgView;
@property (nonatomic, strong) UILabel       *vipValueLB;
@property (nonatomic, strong) UIImageView   *jinbiImgView;
@property (nonatomic, strong) UILabel       *jinbiValueLB;
@end

@implementation YCJGameRoomCell


/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier{
    static NSString *cellIdentifier = @"YCJGameRoomCellCollectionViewCellIdentifier";
    return cellIdentifier;
}

/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找方块视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的方块视图返回
    YCJGameRoomCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:[YCJGameRoomCell cellIdentifier]
                                                  forIndexPath:indexPath];
    return cell;
}

/* 注册了方块视图后，当缓存池中没有底部视图的对象时候，自动调用alloc/initWithFrame创建 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = kSize(8);
        [self configUI];
        [self.containView layoutIfNeeded];
        [self.containView.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)setRoomModel:(YCJRoomListModel *)roomModel {
    
    [self.contentBgView sd_setImageWithURL:[NSURL URLWithString:roomModel.roomImg]];
    [self shadowTitle:roomModel.roomName];
    self.coinLB.text = [NSString stringWithFormat:@"%@金币/次", roomModel.cost];
    
    NSString *imageName = @"";
    if ([roomModel.status isEqualToString:@"0"]) { /// 空闲
        imageName = @"icon_home_game_kxz";
    } else if ([roomModel.status isEqualToString:@"1"]) { /// 游戏中
        imageName = @"icon_home_game_rwz";
    } else if ([roomModel.status isEqualToString:@"2"]) { /// 维护中
        imageName = @"icon_home_game_whz";
    }
    self.statuImgView.image = [UIImage imageNamed:imageName];
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    shadow.shadowOffset = CGSizeMake(0,1);
    
    NSString *jinbi = [NSString stringWithFormat:@"%@倍", roomModel.multiple];
    NSMutableAttributedString *minGold = [[NSMutableAttributedString alloc] initWithString:jinbi attributes: @{NSFontAttributeName: kPingFangRegularFont(14), NSForegroundColorAttributeName: kCommonWhiteColor, NSShadowAttributeName: shadow}];
    [minGold addAttributes:@{NSFontAttributeName: kPingFangRegularFont(10), NSForegroundColorAttributeName: kCommonWhiteColor} range: NSMakeRange(roomModel.multiple.length, 1)];
    self.jinbiValueLB.attributedText = minGold;
    
    NSString *beishu = [NSString stringWithFormat:@"%@+", roomModel.minLevel];
    NSMutableAttributedString *minLevel = [[NSMutableAttributedString alloc] initWithString:beishu attributes: @{NSFontAttributeName: kPingFangRegularFont(14), NSForegroundColorAttributeName: kCommonWhiteColor, NSShadowAttributeName: shadow}];
    self.vipValueLB.attributedText = minLevel;
}

- (void)shadowTitle:(NSString *)title {
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    shadow.shadowOffset =CGSizeMake(0,2);

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightBold], NSForegroundColorAttributeName: kColorHex(0x3A63C1), NSShadowAttributeName: shadow}];
    self.titleLB.attributedText = string;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.containView.bounds;
    [self addGradientLayerWithCorner:self.containView withCornerRadius:8 withLineWidth:4 withColors:@[(id)kColorHex(0xE2E0FF).CGColor,(id)kColorHex(0x6D90E0).CGColor] start:CGPointMake(0, 0) end:CGPointMake(1, 1)];
}


- (void)configUI {
    [self.contentView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.top.bottom.equalTo(self.contentView);
    }];
    
    [self.containView addSubview:self.coinImgView];
    [self.containView addSubview:self.coinLB];
    [self.coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(22);
        make.bottom.mas_equalTo(-kSize(7));
        make.left.mas_equalTo(kSize(10));
    }];
    
    [self.coinLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinImgView.mas_right).offset(10);
        make.centerY.equalTo(self.coinImgView);
    }];
    
    [self.containView addSubview:self.titleBgView];
    self.titleBgView.layer.zPosition = 999;
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-5);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.containView);
        make.bottom.equalTo(self.coinImgView.mas_top).offset(-kSize(8));
    }];
    
    [self.titleBgView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.titleBgView);
    }];
    
    [self.containView addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kSize(8));
        make.right.mas_equalTo(-kSize(8));
        make.bottom.equalTo(self.titleBgView.mas_top).offset(-kSize(8));
    }];
    
    [self.contentBgView addSubview:self.statuImgView];
    [self.statuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentBgView);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(75);
    }];
    
    [self.contentBgView addSubview:self.jinbiImgView];
    [self.jinbiImgView addSubview:self.jinbiValueLB];
    [self.jinbiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBgView).offset(-3);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(50);
    }];
    [self.jinbiValueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jinbiImgView).offset(5);
        make.bottom.equalTo(self.jinbiImgView).offset(5);
        make.left.equalTo(self.jinbiImgView.mas_centerX);
        make.top.equalTo(self.jinbiImgView).offset(-8);
    }];
    
    [self.contentBgView addSubview:self.vipImgView];
    [self.vipImgView addSubview:self.vipValueLB];
    [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jinbiImgView.mas_bottom).offset(5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(50);
    }];
    [self.vipValueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipImgView).offset(5);
        make.bottom.equalTo(self.vipImgView).offset(5);
        make.left.equalTo(self.vipImgView.mas_centerX);
        make.top.equalTo(self.vipImgView).offset(-8);
    }];
}

/**
 *  给view设置渐变色圆角边框
 *
 *  @param view            : 要添加边框的view
 *  @param cornerRadius    : 圆角大小
 *  @param lineWidth       : 线宽
 *  @param colors          : 渐变颜色数组
 *  colors : @[(__bridge id)RGB_COLOR(117, 48,227, 1).CGColor,(__bridge id)RGB_COLOR(225, 175, 204, 1).CGColor]
 */
- (void)addGradientLayerWithCorner:(UIView *)view withCornerRadius:(float)cornerRadius withLineWidth:(float)lineWidth withColors:(NSArray *)colors start:(CGPoint)point1 end:(CGPoint)point2 {
    
    CGRect mapRect = CGRectMake(lineWidth/2, lineWidth/2, view.frame.size.width-lineWidth, view.frame.size.height-lineWidth);
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    gradientLayer.colors = colors;
    gradientLayer.startPoint = point1;
    gradientLayer.endPoint = point2;
    gradientLayer.cornerRadius = cornerRadius;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.lineWidth = lineWidth;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:mapRect cornerRadius:cornerRadius];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor blueColor].CGColor;
    
    gradientLayer.mask = maskLayer;
    [view.layer addSublayer:gradientLayer];
}

#pragma mark -- lazy
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor clearColor];
        _containView.layer.cornerRadius = 9;
        _containView.layer.masksToBounds = NO;
    }
    return _containView;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.cornerRadius = 10;
        _gradientLayer.colors = @[(id)kColorHex(0xA6B5FF).CGColor,(id)kColorHex(0x2A57B8).CGColor];
    }
    return _gradientLayer;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _contentBgView;
}

- (UIImageView *)coinImgView {
    if (!_coinImgView) {
        _coinImgView = [UIImageView new];
        _coinImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coinImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
    }
    return _coinImgView;
}

- (UILabel *)coinLB {
    if (!_coinLB) {
        _coinLB = [[UILabel alloc] init];
        _coinLB.text = @"";
        _coinLB.textAlignment = NSTextAlignmentCenter;
        _coinLB.font = kPingFangSemiboldFont(14);
        _coinLB.textColor = kCommonWhiteColor;
    }
    return _coinLB;
}

- (UIImageView *)titleBgView {
    if (!_titleBgView) {
        _titleBgView = [[UIImageView alloc] init];
        _titleBgView.contentMode = UIViewContentModeScaleAspectFit;
        _titleBgView.image = [UIImage imageNamed:@"icon_home_game_room_title"];
    }
    return _titleBgView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(16);
        _titleLB.textColor = kColorHex(0x3A63C1);
    }
    return _titleLB;
}

- (UIImageView *)statuImgView {
    if (!_statuImgView) {
        _statuImgView = [UIImageView new];
        _statuImgView.contentMode = UIViewContentModeScaleAspectFit;
        _statuImgView.image = [UIImage imageNamed:@"icon_home_game_rwz"];
    }
    return _statuImgView;
}

- (UIImageView *)vipImgView {
    if (!_vipImgView) {
        _vipImgView = [UIImageView new];
        _vipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _vipImgView.image = [UIImage imageNamed:@"icon_home_game_vip"];
    }
    return _vipImgView;
}

- (UILabel *)vipValueLB {
    if (!_vipValueLB) {
        _vipValueLB = [[UILabel alloc] init];
        _vipValueLB.text = @"";
        _vipValueLB.textAlignment = NSTextAlignmentCenter;
        _vipValueLB.font = kPingFangSemiboldFont(16);
        _vipValueLB.textColor = kColorHex(0x3A63C1);
    }
    return _vipValueLB;
}

- (UIImageView *)jinbiImgView {
    if (!_jinbiImgView) {
        _jinbiImgView = [UIImageView new];
        _jinbiImgView.contentMode = UIViewContentModeScaleAspectFit;
        _jinbiImgView.image = [UIImage imageNamed:@"icon_home_game_jifen"];
    }
    return _jinbiImgView;
}

- (UILabel *)jinbiValueLB {
    if (!_jinbiValueLB) {
        _jinbiValueLB = [[UILabel alloc] init];
        _jinbiValueLB.text = @"";
        _jinbiValueLB.textAlignment = NSTextAlignmentCenter;
        _jinbiValueLB.font = kPingFangSemiboldFont(16);
        _jinbiValueLB.textColor = kColorHex(0x3A63C1);
    }
    return _jinbiValueLB;
}

@end
