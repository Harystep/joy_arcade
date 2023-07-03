

#import "KMVIPProcessView.h"

@interface KMVIPProcessView (){
    UIColor *_bgProgressColor;
    NSArray *_colorArr;
    double _progress;
}
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) UIImageView           *vipImgView;
@property (nonatomic, strong) UILabel               *processLB;
@property (nonatomic, strong) CALayer               *bgLayer;
@property (nonatomic, strong) CAGradientLayer       *gradientLayer;
@property (nonatomic, assign) CGFloat               processWidth;
@end

@implementation KMVIPProcessView

- (void)setProgress:(double)progress {
    
    if (progress < 0) {
        _progress = 0.0;
    }
    if (progress > 1) {
        _progress = 1;
    }
    _progress = progress;
    [self updateProgressView];
}

- (void)setColorArr:(NSArray *)colorArr {
    if (colorArr.count >= 2) {
        _colorArr = colorArr;
    }else {
        NSLog(@">>>>>颜色数组个数小于2，显示默认颜色");
    }
}

- (void)updateProgressView {
    self.gradientLayer.frame = CGRectMake(10, 3, (self.processWidth - 10) * self.progress, self.frame.size.height - 6);
    self.gradientLayer.colors = self.colorArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self reload];
        self.processWidth = frame.size.width;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:YCJUserInfoModiyNotification object:nil];
    }
    return self;
}

- (void)reload {
    if ([SKUserInfoManager sharedInstance].userInfoModel) {
        MemberLevelDto *memb = [SKUserInfoManager sharedInstance].userInfoModel.memberLevelDto;
        /// 先重置为0，解决购买后等级提升进度展示异常
        [self setProgress:0];
        [UIView animateWithDuration:0.5 animations:^{
            [self setProgress:(memb.progress / 100.0)];
        }];
        self.processLB.text = [NSString stringWithFormat:@"%ld%%", memb.progress];
        NSString *vipLevel = [NSString stringWithFormat:@"icon_user_vip_%@", memb.level];
        self.vipImgView.image = [UIImage imageNamed:vipLevel];
    } else {
        [self setProgress:0];
        self.processLB.text = @"0%";
        self.vipImgView.image = [UIImage imageNamed:@"icon_user_vip_1"];
    }
}


#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    _colorArr = @[(id)kColorHex(0xB5FFAD).CGColor, (id)kColorHex(0x77D66E).CGColor, (id)kColorHex(0x32BB29).CGColor];
    _progress = 0;
    _bgProgressColor = kColorHex(0x588DC2);
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.vipImgView];
    [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(30);
    }];
    
    [self addSubview:self.processLB];
    [self.processLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self);
    }];
}

-(void)drawRect:(CGRect)rect{

    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        //一般不用frame，因为不支持隐式动画
        _bgLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
        _bgLayer.anchorPoint = CGPointMake(0, 0);
        _bgLayer.backgroundColor = self.bgProgressColor.CGColor;
        [self.contentView.layer addSublayer:_bgLayer];
    }
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(10, 3, (self.processWidth - 10) * self.progress, rect.size.height - 6);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        NSArray *colorArr = self.colorArr;
        _gradientLayer.colors = colorArr;
        _gradientLayer.cornerRadius = (rect.size.height - 6) / 2.;
        [self.contentView.layer addSublayer:_gradientLayer];
    }
    self.contentView.layer.cornerRadius = rect.size.height / 2.;
    self.contentView.clipsToBounds = YES;
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)vipImgView {
    if (!_vipImgView) {
        _vipImgView = [UIImageView new];
        _vipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _vipImgView.image = [UIImage imageNamed:@"icon_user_vip_1"];
    }
    return _vipImgView;
}

- (UILabel *)processLB {
    if (!_processLB) {
        _processLB = [[UILabel alloc] init];
        _processLB.text = @"0%";
        _processLB.textAlignment = NSTextAlignmentCenter;
        _processLB.font = kPingFangMediumFont(14);
        _processLB.textColor = kCommonWhiteColor;
    }
    return _processLB;
}

@end
