#import "SJAlertInGameViewController.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "SJAlertInContentView.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface SJAlertInGameViewController ()
@property (nonatomic, weak) UIView * theAlertView;
@property (nonatomic, weak) UIView * theAlertContentView;
@property (nonatomic, weak) UIButton * theSureButton;
@property (nonatomic, weak) UIButton * theCloseButton;
@property (nonatomic, strong) UIView * theInAlertContentView;
@end
@implementation SJAlertInGameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self configView];
    self.alertDoneSubject = [RACSubject subject];
}
#pragma mark - configView
- (void)configView {
    [self theAlertView];
    if (self.dismissSureButton) {
        if (self.theInAlertContentView) {
            [self.theAlertView addSubview:self.theInAlertContentView];
            [self.theInAlertContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.theAlertView.mas_centerX);
                make.top.mas_equalTo(self.theAlertView.mas_top);
                make.bottom.mas_equalTo(self.theAlertView.mas_bottom).inset(DSize(240));
            }];
        }
        [self theSureButton];
        [self.theSureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.theAlertView.mas_centerX);
            make.height.mas_equalTo(DSize(76));
            make.width.mas_equalTo(DSize(278));
            make.bottom.mas_equalTo(self.theAlertView.mas_bottom).inset(20);
        }];
    } else {
        [self theAlertContentView];
        if (self.theInAlertContentView) {
            [self.theAlertView addSubview:self.theInAlertContentView];
            [self.theInAlertContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.theAlertView.mas_centerX);
                make.top.mas_equalTo(self.theAlertView.mas_top).offset(DSize(40));
            }];
        }
        [self theSureButton];
        [self theCloseButton];
    }
}
- (BOOL)shouldAutorotate {
    return true;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark - public method
- (void)showAlertInViewController:(UIViewController * )viewController {
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:self animated:NO completion:nil];
}
- (void)insertAlertContentView:(UIView * )view {
    self.theInAlertContentView = view;
}
#pragma mark - action
- (void)onSureAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.alertDoneSubject sendNext:@(SDAlertTypeSure)];
}
- (void)onCloseAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.alertDoneSubject sendNext:@(SDAlertTypeCancel)];
}
#pragma mark - lazy
- (UIView * )theAlertView{
    if (!_theAlertView) {
        UIView * theView = [[UIView alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(SF_Float(600));
            make.height.mas_equalTo(SF_Float(444));
        }];
        theView.backgroundColor = UIColor.whiteColor;
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = SF_Float(24);
        _theAlertView = theView;
    }
    return _theAlertView;
}
- (UIView * )theAlertContentView{
    if (!_theAlertContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.theAlertView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.theAlertView).offset(SF_Float(124));
            make.leading.trailing.mas_equalTo(self.theAlertView).inset(20);
            make.height.mas_equalTo(DSize(144));
        }];
        theView.backgroundColor = [UIColor colorForHex:@"#FFF4F4"];
        theView.layer.cornerRadius = SF_Float(14);
        theView.layer.masksToBounds = true;
        _theAlertContentView = theView;
    }
    return _theAlertContentView;
}
- (UIButton * )theSureButton{
    if (!_theSureButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.theAlertView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.theAlertView.mas_trailing).inset(20);
            make.height.mas_equalTo(SF_Float(76));
            make.bottom.equalTo(self.theAlertView.mas_bottom).inset(SF_Float(40));
        }];
        [theView setTitle:ZCLocal(@"确定") forState:UIControlStateNormal];
        [theView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        theView.titleLabel.font = AutoPxFont(26);
        theView.backgroundColor = [UIColor colorForHex:@"#6984EA"];
        theView.layer.cornerRadius = SF_Float(10);
        theView.layer.masksToBounds = true;
        [theView addTarget:self action:@selector(onSureAction:) forControlEvents:UIControlEventTouchUpInside];
        _theSureButton = theView;
    }
    return _theSureButton;
}
- (UIButton * )theCloseButton{
    if (!_theCloseButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SF_Float(76));
            make.centerY.equalTo(self.theSureButton.mas_centerY);
            make.leading.equalTo(self.theAlertView.mas_leading).offset(20);
            make.trailing.mas_equalTo(self.theSureButton.mas_leading).inset(10);
            make.width.mas_equalTo(self.theSureButton.mas_width);
        }];
        [theView setTitle:ZCLocal(@"取消") forState:UIControlStateNormal];
        [theView setTitleColor:[UIColor colorForHex:@"#46599C"] forState:UIControlStateNormal];
        theView.backgroundColor = [UIColor colorForHex:@"#EEF2FF"];
        theView.layer.masksToBounds = true;
        theView.titleLabel.font = AutoPxFont(26);
        theView.layer.cornerRadius = SF_Float(10);
        [theView addTarget:self action:@selector(onCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        _theCloseButton = theView;
    }
    return _theCloseButton;
}

@end
