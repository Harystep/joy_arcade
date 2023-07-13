#import "PPGameMoreFunctionView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "POP.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGameMoreFunctionView ()
@property (nonatomic, weak) UIButton * theMoreButton;
@property (nonatomic, weak) UIView * theFunctionContentView;
@property (nonatomic, strong) UIView * theMaskView;
@end
@implementation PPGameMoreFunctionView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(1052), SF_Float(100));
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self theMoreButton];
  [self theFunctionContentView];
}
#pragma mark - set
- (void)setPlayStatus:(SDGamePlayStatues )playStatus {
  _playStatus = playStatus;
  if (self.playStatus == SDGame_selfPlaying) {
    PPGameActionMoreModel * coinModel = self.btList[0];
    coinModel.isEnable = true;
    PPGameActionMoreModel * settlementModel = self.btList[4];
    settlementModel.isEnable = true;
  } else {
    PPGameActionMoreModel * coinModel = self.btList[0];
    coinModel.isEnable = false;
    PPGameActionMoreModel * settlementModel = self.btList[4];
    settlementModel.isEnable = false;
  }
  [self displayMoreActionView];
}
#pragma mark - display view
- (void)displayMoreActionView {
  [self.theFunctionContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperview];
  }];
  [self.btList enumerateObjectsUsingBlock:^(PPGameActionMoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake( SF_Float(20) + (SF_Float(97) * idx) , SF_Float(4), SF_Float(77), SF_Float(83))];
    [theView setImage:obj.buttonImage forState:UIControlStateNormal];
    if (obj.disableButtonImage) {
      [theView setImage:obj.disableButtonImage forState:UIControlStateDisabled];
    }
    theView.enabled = obj.isEnable;
    [self.theFunctionContentView addSubview:theView];
    [theView addTarget:self action:@selector(onFunctionBtPress:) forControlEvents:UIControlEventTouchUpInside];
    theView.tag = idx;
  }];
  [self mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo((SF_Float(96) + SF_Float(97) * self.btList.count));
  }];
}
#pragma mark - action
- (void)onMorePress:(id)sender {
  self.theMoreButton.selected = !self.theMoreButton.selected;
  if (self.theMoreButton.selected) {
    [self showMoreFunctionButtonAnimation];
  } else {
    [self hideMoreFunctionButtonAnimation];
  }
}
- (void)showMoreFunctionButtonAnimation {
  self.theFunctionContentView.alpha = 1;
}
- (void)hideMoreFunctionButtonAnimation {
  self.theFunctionContentView.alpha = 0;
}
#pragma mark - action
- (void)onFunctionBtPress:(id)sender {
  UIButton * bt = sender;
  PPGameActionMoreModel * model = [self.btList objectAtIndex:bt.tag];
  [model.doneSubject sendNext: model];
}
#pragma mark - set
- (void)setBtList:(NSArray<PPGameActionMoreModel *> *)btList {
  _btList = btList;
  [self displayMoreActionView];
}
#pragma mark - get
#pragma mark - lazy UI
- (UIButton * )theMoreButton{
  if (!_theMoreButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self);
      make.width.mas_equalTo(SF_Float(63));
      make.height.mas_equalTo(SF_Float(83));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_staic_more_1"] forState:UIControlStateNormal];
    [theView setImage:[PPImageUtil imageNamed:@"ico_staic_more_2"] forState:UIControlStateSelected];
    [theView addTarget:self action:@selector(onMorePress:) forControlEvents:UIControlEventTouchUpInside];
    _theMoreButton = theView;
  }
  return _theMoreButton;
}
- (UIView * )theFunctionContentView{
  if (!_theFunctionContentView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theMoreButton.mas_right).offset(SF_Float(13));
      make.centerY.equalTo(self);
      make.right.equalTo(self);
      make.height.mas_equalTo(SF_Float(100));
    }];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(8);
    theView.layer.borderColor = [UIColor colorForHex:@"#78B6CD"].CGColor;
    theView.layer.borderWidth = 1;
    theView.alpha = 0;
    _theFunctionContentView = theView;
  }
  return _theFunctionContentView;
}
@end
