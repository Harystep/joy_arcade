#import "PPStatisticalintegralView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "UICountingLabel.h"
#import "POP.h"
#import "SDGameDefineHeader.h"

#import "AppDefineHeader.h"

@interface PPStatisticalintegralView ()
@property (nonatomic, weak) UIButton * theOffPlaneButton;
@property (nonatomic, weak) UICountingLabel * theCountingLabel;
@end
@implementation PPStatisticalintegralView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, DSize(220), DSize(66));
        self.offPlaneSubject = [RACSubject subject];
        [self configView];
    }
    return self;
}
#pragma mark - config
- (void)configView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = DSize(33);
    [self theOffPlaneButton];
    [self theCountingLabel];
}
#pragma mark - set
- (void)setIntegralValue:(NSInteger)integralValue {
    NSInteger currentValue = self.integralValue;
    _integralValue = integralValue;
    if (currentValue > _integralValue) {
        NSString * countingValue = [NSString stringWithFormat:@"赢 %ld %@", self.integralValue, ZCLocal(@"分")];
        if (self.type == 5) {
            countingValue = [NSString stringWithFormat:@"赢 %l%ld石", self.integralValue];
        }
        CGSize countingValueSize = [countingValue sizeWithAttributes:@{NSFontAttributeName: self.theCountingLabel.font}];
        CGFloat maxWidth = countingValueSize.width + DSize(40) + DSize(75) + DSize(15);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, self.frame.size.height);
        self.theCountingLabel.format = countingValue;
        [self.theCountingLabel countFrom:currentValue to:self.integralValue withDuration:1];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString * countingValue = [NSString stringWithFormat:@"%@ %ld %@", ZCLocal(@"赢"), self.integralValue, ZCLocal(@"分")];
            if (self.type == 5) {
                countingValue = [NSString stringWithFormat:@"赢 %ld 钻石", self.integralValue];
            }
            CGSize countingValueSize = [countingValue sizeWithAttributes:@{NSFontAttributeName: self.theCountingLabel.font}];
            CGFloat maxWidth = countingValueSize.width + DSize(40) + DSize(75) + DSize(15);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, self.frame.size.height);
            self.theCountingLabel.format = countingValue;
            [self.theCountingLabel countFrom:currentValue to:self.integralValue withDuration:0.5];
        });
    }
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (self.type == game_type_pushCoin) {
        self.theCountingLabel.format = [NSString stringWithFormat:@"%@ %ld %@", ZCLocal(@"赢"), 0, ZCLocal(@"分")];
        [self.theOffPlaneButton setTitle:ZCLocal(@"下机_push") forState:UIControlStateNormal];
        NSLog(@"===>");
    } else if (self.type == 5) {
        self.theCountingLabel.format = @"赢 %ld 钻石";
        [self.theOffPlaneButton setTitle:@"下机" forState:UIControlStateNormal];
    } else if (self.type == 6) {
        self.theCountingLabel.format = @"赢 %ld 分";
        [self.theOffPlaneButton setTitle:@"结算" forState:UIControlStateNormal];
    }
}
#pragma mark - public method
#pragma mark - action
- (void)onOffPlanePress:(id)sender {
    [self.offPlaneSubject sendNext:sender];
}
#pragma mark - lazy UI
- (UIButton * )theOffPlaneButton{
    if (!_theOffPlaneButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.mas_equalTo(DSize(71));
            make.height.mas_equalTo(DSize(40));
            make.right.equalTo(self.mas_right).offset(-DSize(15));
        }];
        theView.backgroundColor = [UIColor colorForHex:@"#F9E55E"];
        [theView setTitle:ZCLocal(@"下机_push") forState:UIControlStateNormal];
        theView.titleLabel.font = AutoMediumPxFont(22);
        [theView addTarget:self action:@selector(onOffPlanePress:) forControlEvents:UIControlEventTouchUpInside];
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = DSize(20);
        _theOffPlaneButton = theView;
    }
    return _theOffPlaneButton;
}
- (UICountingLabel * )theCountingLabel{
    if (!_theCountingLabel) {
        UICountingLabel * theView = [[UICountingLabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(DSize(20));
            make.centerY.equalTo(self);
            make.right.equalTo(self.theOffPlaneButton.mas_left).offset(-DSize(20));
        }];
        theView.font = AutoBoldPxFont(26);
        theView.textColor = [UIColor colorForHex:@"#F9E55E"];
        theView.format = @"赢 %ld 分";
        _theCountingLabel = theView;
    }
    return _theCountingLabel;
}
@end
