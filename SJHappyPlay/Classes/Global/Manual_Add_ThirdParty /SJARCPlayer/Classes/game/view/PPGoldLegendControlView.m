#import "PPGoldLegendControlView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPSaintGameControlButton.h"
#import "PPImageUtil.h"
#import "PPSaintPushCoinView.h"
#import "PPThread.h"

#import "AppDefineHeader.h"

@interface PPGoldLegendControlView ()
@property (nonatomic, weak) PPSaintGameControlButton * thePushCoinButton;
@property (nonatomic, weak) UIButton * theCoinDoubleButton;
@property (nonatomic, weak) UIButton * theLockButton;
@property (nonatomic, weak) UIButton * theFireAutonButton;
@property (nonatomic, weak) PPSaintGameControlButton * theControlLeftButton;
@property (nonatomic, weak) PPSaintGameControlButton * theControlRightButton;
@property (nonatomic, weak) UIButton * theControlFireButton;
@property (nonatomic, weak) PPSaintPushCoinView * theSaintPushCoinView;
@property (nonatomic, strong) PPThread * fireTouchThread;
@property (nonatomic, assign) NSInteger fire_count;
@property (nonatomic, assign) NSInteger had_fire_count;
@end
@implementation PPGoldLegendControlView

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configView];
    [self configData];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self thePushCoinButton];
  [self theCoinDoubleButton];
  [self theLockButton];
  [self theFireAutonButton];
  [self theControlLeftButton];
  [self theControlRightButton];
  [self theControlFireButton];
    @weakify_self;
    [self.thePushCoinButton.touchSubject subscribeNext:^(id  _Nullable x) {
      @strongify_self;
      NSInteger actionType = [x integerValue];
      if (actionType == ControlTouchDown) {
          [self.theSaintPushCoinView showButtons];
      } else if (actionType == ControlTouchUp) {
      } else if (actionType == ControlTouchSimple) {
          [self.simpleControlSubject sendNext:@(goldLegendControl_pushCoin)];
          [self.theSaintPushCoinView hideButtons];
      }
    }];
}
- (void)configData {
  self.simpleControlSubject = [RACSubject subject];
  self.controlLeftSubject = self.theControlLeftButton.touchSubject;
  self.controlRightSubject = self.theControlRightButton.touchSubject;
    self.fireTouchThread = [[PPThread alloc] init:103];
}
#pragma mark - action
- (void)onPushCoinPress:(id)sender {
  [self.simpleControlSubject sendNext:@(goldLegendControl_pushCoin)];
}
- (void)onFireDoublePress:(id)sender {
  [self.simpleControlSubject sendNext:@(goldLegendControl_fireDouble)];
}
- (void)onFireLockPress:(id)sender {
  [self.simpleControlSubject sendNext:@(goldLegendControl_fireLock)];
}
- (void)onFireAutoPress:(id)sender {
  [self.simpleControlSubject sendNext:@(goldLegendControl_fireAuto)];
}
- (void)onFirePress:(id)sender {
  [self.simpleControlSubject sendNext:@(goldLegendControl_fireSimple)];
}
- (void)delayFire {
    if (self.had_fire_count < self.fire_count) {
        @weakify_self;
        [self.fireTouchThread delay:0.26 runBlock:^{
          @strongify_self;
          dispatch_async(dispatch_get_main_queue(), ^{
              @synchronized (self) {
                  self.had_fire_count += 1;
                  [self.simpleControlSubject sendNext:@(goldLegendControl_pushCoin)];
                  NSLog(@"[fire] ----> %ld", self.had_fire_count);
                  [self delayFire];
              }
          });
        }];
    }
}
- (void)pushCoinWithCoinCount:(NSInteger)count {
    @synchronized (self) {
        if (self.had_fire_count == self.fire_count || self.had_fire_count > self.fire_count) {
            self.had_fire_count = 0;
            self.fire_count = count;
        } else if (self.had_fire_count < self.fire_count) {
            self.fire_count += count;
        }
        [self delayFire];
    }
}
#pragma mark - lazy
- (PPSaintGameControlButton * )thePushCoinButton{
  if (!_thePushCoinButton) {
      PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(90));
      make.height.mas_equalTo(SF_Float(90));
      make.left.equalTo(self).offset(SF_Float(20));
      make.top.equalTo(self);
    }];
      [theView showPushCoinBt];
    _thePushCoinButton = theView;
  }
  return _thePushCoinButton;
}
- (UIButton * )theCoinDoubleButton{
  if (!_theCoinDoubleButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(90));
      make.height.mas_equalTo(SF_Float(90));
      make.left.equalTo(self).offset(SF_Float(20));
      make.top.equalTo(self.thePushCoinButton.mas_bottom).offset(SF_Float(102));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_saint_fire_double_bt"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onFireDoublePress:) forControlEvents:UIControlEventTouchUpInside];
    _theCoinDoubleButton = theView;
  }
  return _theCoinDoubleButton;
}
- (UIButton * )theLockButton{
  if (!_theLockButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(90));
      make.height.mas_equalTo(SF_Float(90));
      make.right.mas_equalTo(self.mas_right).offset(SF_Float(-20));
      make.top.equalTo(self);
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_gold_legend_lock"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onFireLockPress:) forControlEvents:UIControlEventTouchUpInside];
    _theLockButton = theView;
  }
  return _theLockButton;
}
- (UIButton * )theFireAutonButton{
  if (!_theFireAutonButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(90));
      make.height.mas_equalTo(SF_Float(90));
      make.right.mas_equalTo(self.mas_right).offset(SF_Float(-20));
      make.top.equalTo(self.theLockButton.mas_bottom).offset(SF_Float(102));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_gold_legend_auto"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onFireAutoPress:) forControlEvents:UIControlEventTouchUpInside];
    _theFireAutonButton = theView;
  }
  return _theFireAutonButton;
}
- (PPSaintGameControlButton * )theControlLeftButton{
  if (!_theControlLeftButton) {
    PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mas_centerX).offset(SF_Float(-84));
      make.bottom.equalTo(self.mas_bottom);
      make.width.mas_equalTo(SF_Float(84));
      make.height.mas_equalTo(SF_Float(84));
    }];
    theView.actionLogoImage = [PPImageUtil imageNamed:@"ico_gold_legend_left"];
    _theControlLeftButton = theView;
  }
  return _theControlLeftButton;
}
- (PPSaintGameControlButton * )theControlRightButton{
  if (!_theControlRightButton) {
    PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mas_centerX).offset(SF_Float(84));
      make.bottom.equalTo(self.mas_bottom);
      make.width.mas_equalTo(SF_Float(84));
      make.height.mas_equalTo(SF_Float(84));
    }];
    theView.actionLogoImage = [PPImageUtil imageNamed:@"ico_gold_legend_right"];
    _theControlRightButton = theView;
  }
  return _theControlRightButton;
}
- (UIButton * )theControlFireButton{
  if (!_theControlFireButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(140));
      make.height.mas_equalTo(SF_Float(140));
      make.centerX.equalTo(self.mas_centerX);
      make.bottom.equalTo(self.mas_bottom).offset(SF_Float(-67));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_gold_legend_fire"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onFirePress:) forControlEvents:UIControlEventTouchUpInside];
    _theControlFireButton = theView;
  }
  return _theControlFireButton;
}
- (PPSaintPushCoinView *)theSaintPushCoinView{
    if (!_theSaintPushCoinView) {
        PPSaintPushCoinView * theView = [[PPSaintPushCoinView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thePushCoinButton.mas_right).offset(SF_Float(30));
            make.top.equalTo(self.thePushCoinButton.mas_top);
            make.width.mas_equalTo(SF_Float(90));
            make.height.mas_equalTo(SF_Float(300));
        }];
        theView.pushCoinDelegate = self;
        [theView setHidden:true];
        _theSaintPushCoinView = theView;
    }
    return _theSaintPushCoinView;
}
@end
