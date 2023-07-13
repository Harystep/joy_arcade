#import "PPDefineAlertContentView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"

#import "AppDefineHeader.h"

@interface PPDefineAlertContentView ()
@property (nonatomic, weak) UILabel * theTitleLabel;
@end
@implementation PPDefineAlertContentView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
#pragma mark - config
- (void)configView {
    [self theTitleLabel];
    [self theMessageLabel];
}
#pragma mark - set
-(void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle;
    self.theTitleLabel.text = self.alertTitle;
}
- (void)setAlertMessage:(NSString *)alertMessage {
    _alertMessage = alertMessage;
    self.theMessageLabel.text = self.alertMessage;
}
#pragma mark - lazy
- (UILabel * )theTitleLabel{
    if (!_theTitleLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
        }];
        theView.font = AutoBoldPxFont(32);
        theView.textColor = [UIColor blackColor];
        _theTitleLabel = theView;
    }
    return _theTitleLabel;
}
- (UILabel * )theMessageLabel{
    if (!_theMessageLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.theTitleLabel.mas_bottom).offset(SF_Float(110));
            make.width.mas_equalTo(SF_Float(520));
        }];
        theView.font = AutoBoldPxFont(26);
        theView.textColor = [UIColor colorForHex:@"#444444"];
        theView.numberOfLines = 0;
        theView.textAlignment = NSTextAlignmentCenter;
        _theMessageLabel = theView;
    }
    return _theMessageLabel;
}

@end
