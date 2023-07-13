

#import "SJUserRechargeCoinDataView.h"
#import "PPImageUtil.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"

@interface SJUserRechargeCoinDataView ()

@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *stoneL;
@property (nonatomic,strong) UILabel *pointL;

@end

@implementation SJUserRechargeCoinDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView *stoneView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"img_stone_bg_a"]];
    [self addSubview:stoneView];
    [stoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(DSize(172));
    }];
    
    UIImageView *priceView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"img_coin_bg_a"]];
    [self addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.height.mas_equalTo(DSize(52));
        make.width.mas_equalTo(DSize(172));
        make.trailing.mas_equalTo(stoneView.mas_leading).inset(DSize(18));
    }];
    
    UIImageView *pointView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"img_point_bg_a"]];
    [self addSubview:pointView];
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(stoneView.mas_trailing).offset(DSize(18));
        make.width.mas_equalTo(DSize(172));
    }];
    
    self.priceL = [self setupContentView:priceView];
    self.stoneL = [self setupContentView:stoneView];
    self.pointL = [self setupContentView:pointView];
    
}

- (UILabel *)setupContentView:(UIView *)view {
    UILabel *lb = [[UILabel alloc] init];
    [view addSubview:lb];
    lb.font = AutoBoldPxFont(28);    
    lb.textColor = UIColor.whiteColor;
    lb.textAlignment = NSTextAlignmentCenter;
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view.mas_trailing).inset(DSize(10));
        make.top.bottom.mas_equalTo(view);
        make.leading.mas_equalTo(view.mas_leading).offset(DSize(48));
    }];
    return lb;
}

- (void)setPointValue:(NSString *)pointValue {
    _pointValue = pointValue;
    
    [self handleLargeValue:pointValue view:self.pointL];
}

- (void)setStoneValue:(NSString *)stoneValue {
    _stoneValue = stoneValue;
    [self handleLargeValue:stoneValue view:self.stoneL];
}

- (void)setPriceValue:(NSString *)priceValue {
    _priceValue = priceValue;
    [self handleLargeValue:priceValue view:self.priceL];
}

- (void)handleLargeValue:(NSString *)value view:(UILabel *)contentL {
    if([value integerValue] > 1000000 && [value integerValue] < 10000000) {
        NSInteger num = [value integerValue];
        contentL.text = [NSString stringWithFormat:@"%.1f万", num/10000.0];
    } else if([value integerValue] >= 10000000) {
        NSInteger num = [value integerValue];
        contentL.text = [NSString stringWithFormat:@"%.2f亿", num/100000000.0];
    } else {
        contentL.text = value;
    }
}

@end
