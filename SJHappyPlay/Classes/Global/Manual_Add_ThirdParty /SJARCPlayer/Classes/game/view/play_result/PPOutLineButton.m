#import "PPOutLineButton.h"
#import "PPOutlineLabel.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPOutLineButton()
@property (nonatomic, weak) UIImageView * theBgImageView;
@property (nonatomic, weak) PPOutlineLabel * theTitleLabel;
@end
@implementation PPOutLineButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self theBgImageView];
        [self theTitleLabel];
    }
    return self;
}
- (void)setBgImageLink:(NSString *)bgImageLink
{
    _bgImageLink = bgImageLink;
    self.theBgImageView.image = [PPImageUtil imageNamed:_bgImageLink];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.theTitleLabel.text = title;
}
- (UIImageView *)theBgImageView
{
    if (!_theBgImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _theBgImageView = theView;
    }
    return _theBgImageView;
}
- (PPOutlineLabel *)theTitleLabel
{
    if (!_theTitleLabel) {
        PPOutlineLabel * theView = [[PPOutlineLabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        theView.textAlignment = NSTextAlignmentCenter;
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        theView.outLinetextColor = [UIColor blackColor];
        theView.labelTextColor = [UIColor whiteColor];
        theView.font = AutoBoldPxFont(34);
        _theTitleLabel = theView;
    }
    return _theTitleLabel;
}
@end
