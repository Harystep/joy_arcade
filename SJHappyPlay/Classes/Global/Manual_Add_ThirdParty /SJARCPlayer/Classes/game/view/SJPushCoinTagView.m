#import "SJPushCoinTagView.h"
#import "POP.h"
#import "Masonry.h"

#import "AppDefineHeader.h"

@interface SJPushCoinTagView ()
@property (nonatomic, weak) UILabel * theTagLabel;
@end
@implementation SJPushCoinTagView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView {
    self.frame = CGRectMake(0, 0, DSize(40), DSize(40));
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = DSize(20);
    self.theTagLabel.text = @"0";
}
- (void)setCount:(NSInteger) count {
    self.theTagLabel.text = [NSString stringWithFormat:@"%ld", count];
    [self.theTagLabel sizeToFit];
    POPBasicAnimation * scaleBigAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleBigAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
    [self.theTagLabel pop_addAnimation:scaleBigAnimation forKey:@"scale_big_animation"];
    POPBasicAnimation * scaleMiniAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleMiniAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleMiniAnimation.beginTime =  CACurrentMediaTime() + 0.2;
    [self.theTagLabel pop_addAnimation:scaleMiniAnimation forKey:@"scale_big_animation"];
}
#pragma mark - lazy UI
- (UILabel *)theTagLabel{
    if (!_theTagLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        theView.textColor = UIColor.whiteColor;
        theView.font = AutoPxFont(20);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        theView.textAlignment = NSTextAlignmentCenter;
        _theTagLabel = theView;
    }
    return _theTagLabel;
}
@end
