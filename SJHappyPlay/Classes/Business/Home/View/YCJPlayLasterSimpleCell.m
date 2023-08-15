//
//  YCJPlayLasterSimpleCell.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJPlayLasterSimpleCell.h"

@interface YCJPlayLasterSimpleCell ()
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) UIImageView   *titleBgView;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *titleL;

@end

@implementation YCJPlayLasterSimpleCell

/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找方块视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的方块视图返回
    YCJPlayLasterSimpleCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"YCJPlayLasterSimpleCell"
                                                  forIndexPath:indexPath];
    return cell;
}

/* 注册了方块视图后，当缓存池中没有底部视图的对象时候，自动调用alloc/initWithFrame创建 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = kSize(8);
        [self configUI];
        [self.containView layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addGradientLayerWithCorner:self.containView withCornerRadius:6 withLineWidth:4 withColors:@[(id)rgba(166, 181, 255, 1).CGColor,(id)rgba(42, 87, 184, 1).CGColor] start:CGPointMake(0.5, 0) end:CGPointMake(0.5, 1)];
    
}


- (void)configUI {
    [self.contentView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(3);
        make.top.trailing.bottom.equalTo(self.contentView);
    }];

    [self.contentView addSubview:self.titleBgView];
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(8);
        make.height.mas_equalTo(17);
    }];

    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.contentView).inset(4);
        make.height.mas_equalTo(kSize(49));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(7);
    }];
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:@"https://lmg.jj20.com/up/allimg/4k/s/02/2109251913501339-0-lp.jpg"]];
    [self.iconIv setViewCornerRadiu:4];
    
    self.titleL = [self createSimpleLabelWithTitle:ZCLocalizedString(@"金币传说1", nil) font:10 bold:NO color:rgba(58, 99, 193, 1)];
    [self.titleBgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleBgView);
        make.leading.trailing.mas_equalTo(self.titleBgView).inset(6);
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
    
//    CGRect mapRect = CGRectMake(lineWidth/2, lineWidth/2, view.frame.size.width-lineWidth, view.frame.size.height-lineWidth);
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    gradientLayer.colors = colors;
    gradientLayer.startPoint = point1;
    gradientLayer.endPoint = point2;
    gradientLayer.cornerRadius = cornerRadius;
    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.lineWidth = lineWidth;
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:mapRect cornerRadius:cornerRadius];
//    maskLayer.path = path.CGPath;
//    maskLayer.fillColor = [UIColor clearColor].CGColor;
//    maskLayer.strokeColor = [UIColor blueColor].CGColor;
//
//    gradientLayer.mask = maskLayer;
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

- (UIImageView *)titleBgView {
    if (!_titleBgView) {
        _titleBgView = [[UIImageView alloc] init];
        _titleBgView.contentMode = UIViewContentModeScaleAspectFill;
        _titleBgView.image = [UIImage imageNamed:@"icon_home_game_room_title"];
    }
    return _titleBgView;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:kSafeContentString(dataDic[@"roomImg"])] placeholderImage:nil];
    self.titleL.text = dataDic[@"roomName"];
}

@end
