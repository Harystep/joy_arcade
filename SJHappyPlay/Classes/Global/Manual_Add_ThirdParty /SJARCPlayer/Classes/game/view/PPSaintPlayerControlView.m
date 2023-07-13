#import "PPSaintPlayerControlView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "SJPlayRetain.h"
#import "PPThread.h"
#import "PPTcpMoveDirctionData.h"
#import "PPImageUtil.h"
#import "PPSaintPushCoinView.h"
#import "SJPushCoinTagView.h"
#import "PPNetworkConfig.h"
#import "PPGameConfig.h"

#import "AppDefineHeader.h"

@interface PPSaintPlayerControlView ()<UIGestureRecognizerDelegate, SDSaintPushCoinViewDelegate>
@property (nonatomic, weak) UIView * theControllDirctionView;
@property (nonatomic, weak) UIImageView * theControllDirctionBgImageView;

@property (nonatomic, weak) UIImageView * thePointImageView;
@property (nonatomic, assign) SDMoveDirctionType currentDirction;
@property (nonatomic, assign) SDMoveDirctionType lastDirction;
@property (nonatomic, strong) PPThread * touchThread;
@property (nonatomic, strong) PPThread * fireTouchThread;
@property (nonatomic, assign) NSInteger actionFiring;
@property (nonatomic, weak) UIImageView * theDirctionImageView;
@property (nonatomic, weak) PPSaintPushCoinView * theSaintPushCoinView;
@property (nonatomic, assign) NSInteger fire_count;
@property (nonatomic, assign) NSInteger had_fire_count;
@property (nonatomic, weak) SJPushCoinTagView * pushCoinTagView;
@end
@implementation PPSaintPlayerControlView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, DSize(374));
    [self configView];
    [self configData];
  }
  return self;
}
- (void)layoutSubviews {
  [super layoutSubviews];
  self.thePointImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
}
#pragma mark - config
- (void)configView {
  [self theFireButton];
  [self theRaisebetButton];
  [self thePushCoinButton];
    [self theSaintPushCoinView];
  @weakify_self;
  [self.theFireButton.touchSubject subscribeNext:^(id  _Nullable x) {
    @strongify_self;
    NSInteger actionType = [x integerValue];
    if (actionType == ControlTouchDown) {
      self.actionFiring = true;
      [self.longTouchActionSubject sendNext:@(self.theFireButton.tag)];
    } else if (actionType == ControlTouchUp) {
      self.actionFiring = false;
      [self.longTouchEndSubject sendNext:@(self.theFireButton.tag)];
    } else if (actionType == ControlTouchSimple) {
      [self.simpleTouchSubject sendNext:@(self.theFireButton.tag)];
    }
  }];
  [self.theRaisebetButton.touchSubject subscribeNext:^(id  _Nullable x) {
    @strongify_self;
    NSInteger actionType = [x integerValue];
    if (actionType == ControlTouchUp) {
      [self.simpleTouchSubject sendNext:@(self.theRaisebetButton.tag)];
    } else if (actionType == ControlTouchSimple) {
      [self.simpleTouchSubject sendNext:@(self.theRaisebetButton.tag)];
    }
  }];
  [self.thePushCoinButton.touchSubject subscribeNext:^(id  _Nullable x) {
    @strongify_self;
    NSInteger actionType = [x integerValue];
    if (actionType == ControlTouchDown) {
        [self.theSaintPushCoinView showButtons];
    } else if (actionType == ControlTouchUp) {
    } else if (actionType == ControlTouchSimple) {
      [self.simpleTouchSubject sendNext:@(self.thePushCoinButton.tag)];
        [self.theSaintPushCoinView hideButtons];
    }
  }];
  [self theControllDirctionBgImageView];
}
- (void)configData {
  self.longTouchActionSubject = [RACSubject subject];
  self.longTouchEndSubject = [RACSubject subject];
  self.simpleTouchSubject = [RACSubject subject];
    self.arcadeCoinSubject = [RACSubject subject];
  self.touchThread = [[PPThread alloc] init:100];
  self.fireTouchThread = [[PPThread alloc] init:101];
}
#pragma mark - set
- (void)setMargin:(CGFloat)margin {
  _margin = margin;
  [self.theFireButton mas_updateConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.mas_right).offset( -self.margin / 2.0);
  }];
  [self.theControllDirctionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(self.margin / 2.0 + DSize(60));
  }];
}
- (void)setCurrentDirction:(SDMoveDirctionType)currentDirction {
  _currentDirction = currentDirction;
}
#pragma mark - public method
- (void)endTouchAction {
  if (self.lastDirction) {
    [self touchEnd];
  }
  if (self.actionFiring) {
    [self.longTouchEndSubject sendNext:@(self.theFireButton.tag)];
    self.actionFiring = false;
  }
  [self.fireTouchThread interrupt];
}
#pragma mark - action
- (void)delayFire {
    @synchronized (self) {
    if (self.had_fire_count < self.fire_count) {
        @weakify_self;
        [self.fireTouchThread delay:0.26 runBlock:^{
          @strongify_self;
          dispatch_async(dispatch_get_main_queue(), ^{
                  self.had_fire_count += 1;
              if (![PPGameConfig sharedInstance].autoPushCoin) {
                  [self.simpleTouchSubject sendNext:@(self.thePushCoinButton.tag)];
              }
                  [self delayFire];
                  [self.pushCoinTagView setHidden:false];
                  [self.pushCoinTagView setCount: self.fire_count - self.had_fire_count];
                  if (self.had_fire_count >= self.fire_count) {
                      [self.pushCoinTagView setHidden:true];
                  }
          });
        }];
    } else {
        [self.pushCoinTagView setHidden:true];
    }
    }
}
- (void)delayRunTouchBeginAction:(SDMoveDirctionType)actionType{
  @weakify_self;
  [self.touchThread delay:0.2 runBlock:^{
    @strongify_self;
    self.currentDirction = actionType;
    if (self.currentDirction > 0) {
      [[self longTouchActionSubject] sendNext:@(self.currentDirction)];
    }
  }];
}
- (void)on_touch_long_start_action:(id)sender
{
  [self.longTouchActionSubject sendNext:sender];
}
- (void)on_touch_end_action:(id)sender
{
  [self.longTouchEndSubject sendNext:sender];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch * touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.theControllDirctionView];
  CGFloat distance = [self getDistanceDiectionPoint:touchPoint];
  if (distance > DSize(200)) {
    return;
  }
  CGPoint pointPoint = [self getScopeDirctionWithPoint:touchPoint];
  CGPoint center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  CGFloat tanx = [self getTanPoint:pointPoint inCenterPoint:center];
  SDMoveDirctionType actionType = 0;
  if (tanx > 0 && tanx < M_PI / 4.0) {
    actionType = SDMoveDirctionRight;
  } else if (tanx >= M_PI / 4.0 && tanx < M_PI / 4.0 * 3) {
    actionType = SDMoveDirctionDown;
  } else if (tanx >= M_PI / 4.0 * 3 && tanx < M_PI / 4.0 * 5) {
    actionType = SDMoveDirctionLeft;
  } else if (tanx >= M_PI / 4.0 * 5 && tanx < M_PI / 4.0 * 7) {
    actionType = SDMoveDirctionUp;
  } else if (tanx >= M_PI / 4.0 * 7){
    actionType = SDMoveDirctionRight;
  } else if (tanx <= 0 && tanx > -M_PI / 4.0) {
    actionType = SDMoveDirctionRight;
  } else if (tanx <= -M_PI / 4.0 && tanx >= -M_PI / 2.0) {
    actionType = SDMoveDirctionUp;
  }
  self.lastDirction = actionType;
  [self delayRunTouchBeginAction:actionType];
    [self showTouchDirctionView:actionType];
  self.thePointImageView.center = pointPoint;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch * touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.theControllDirctionView];
  CGFloat distance = [self getDistanceDiectionPoint:touchPoint];
  if (distance > DSize(200)) {
    return;
  }
  CGPoint pointPoint = [self getScopeDirctionWithPoint:touchPoint];
  CGPoint center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  CGFloat tanx = [self getTanPoint:pointPoint inCenterPoint:center];
  if (distance < DSize(58.5)) {
    return;
  }
  SDMoveDirctionType actionType = 0;
  if (tanx > 0 && tanx < M_PI / 4.0) {
    actionType = SDMoveDirctionRight;
  } else if (tanx >= M_PI / 4.0 && tanx < M_PI / 4.0 * 3) {
    actionType = SDMoveDirctionDown;
  } else if (tanx >= M_PI / 4.0 * 3 && tanx < M_PI / 4.0 * 5) {
    actionType = SDMoveDirctionLeft;
  } else if (tanx >= M_PI / 4.0 * 5 && tanx < M_PI / 4.0 * 7) {
    actionType = SDMoveDirctionUp;
  } else if (tanx >= M_PI / 4.0 * 7){
    actionType = SDMoveDirctionRight;
  } else if (tanx <= 0 && tanx > -M_PI / 4.0) {
    actionType = SDMoveDirctionRight;
  } else if (tanx <= -M_PI / 4.0 && tanx >= -M_PI / 2.0) {
    actionType = SDMoveDirctionUp;
  }
  if (self.lastDirction != actionType) {
    [[self touchThread] interrupt];
    if (self.currentDirction > 0 ) {
      [self.longTouchEndSubject sendNext:@(self.lastDirction)];
      [self delayRunTouchBeginAction:actionType];
    } else {
      [self delayRunTouchBeginAction:actionType];
    }
    self.lastDirction = actionType;
  }
    [self showTouchDirctionView:actionType];
  self.thePointImageView.center = pointPoint;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.thePointImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  NSLog(@"touchesEnded");
  if (self.lastDirction) {
    [self touchEnd];
  }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.thePointImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  NSLog(@"touchesCancelled");
  if (self.lastDirction) {
    [self touchEnd];
  }
}
- (void)touchEnd {
  [self.touchThread interrupt];
  if (self.currentDirction > 0) {
    [self.longTouchEndSubject sendNext:@(self.currentDirction)];
  } else {
    [self.simpleTouchSubject sendNext:@(self.lastDirction)];
  }
  self.currentDirction = 0;
  self.lastDirction = 0;
    [self hideTouchDirctionView];
}
- (CGPoint)getScopeDirctionWithPoint:(CGPoint)point {
  CGPoint center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  CGFloat distance = [self getDistanceDiectionPoint:point];
  CGFloat tanx = [self getTanPoint:point inCenterPoint:center];
  CGFloat tanxma = tanx / M_PI * 180;
  NSLog(@"当前位置的 角度 %f",tanxma);
  if (distance > DSize(190)) {
    CGFloat maxX = cosf(tanx) * DSize(107.3);
    CGFloat maxY = sinf(tanx) * DSize(107.3);
    return CGPointMake(maxX + center.x, maxY + center.y);
  }
  return point;
}
- (CGFloat)getDistanceDiectionPoint:(CGPoint)point {
  CGPoint center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0f, self.theControllDirctionView.frame.size.height / 2.0f);
  CGFloat offsetx = pow((center.x - point.x), 2);
  CGFloat offsety = pow((center.y - point.y), 2);
  return sqrt(offsetx + offsety);
}
- (CGFloat)getTanPoint:(CGPoint) point inCenterPoint:(CGPoint) center {
  CGFloat offsetx = point.x - center.x;
  CGFloat offsety = point.y - center.y;
  CGFloat tanx = 0;
  if (offsetx == 0) {
    if (center.y > point.y) {
      tanx = M_PI / 2.0;
    } else {
      tanx = M_PI / 2.0 * 3;
    }
  } else {
    tanx = atan(offsety / offsetx);
  }
  CGFloat tanxma = tanx / M_PI * 180;
  NSLog(@"转换之前位置的 角度 %f",tanxma);
  if (point.x < center.x && point.y > center.y) {
    tanx = M_PI  + tanx;
  } else if (point.x < center.x && point.y < center.y) {
    tanx = M_PI + tanx;
  } 
  return tanx;
}
- (void)showTouchDirctionView:(SDMoveDirctionType ) actionType {
  [self.theDirctionImageView setHidden:false];
  if (actionType == SDMoveDirctionLeft) {
    self.theDirctionImageView.frame = CGRectMake(0, 0, DSize(80), DSize(190));
    self.theDirctionImageView.image = [PPImageUtil imageNamed:@"ico_control_left"];
    self.theDirctionImageView.center = CGPointMake(self.theDirctionImageView.frame.size.width / 2.0 + DSize(2), self.theControllDirctionView.frame.size.height / 2.0f);
  } else if (actionType == SDMoveDirctionUp) {
    self.theDirctionImageView.frame = CGRectMake(0, 0, DSize(190), DSize(80));
    self.theDirctionImageView.image = [PPImageUtil imageNamed:@"ico_control_up"];
    self.theDirctionImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0 + DSize(2), self.theDirctionImageView.frame.size.height / 2.0f + DSize(2));
  } else if (actionType == SDMoveDirctionRight) {
    self.theDirctionImageView.frame = CGRectMake(0, 0, DSize(80), DSize(190));
    self.theDirctionImageView.image = [PPImageUtil imageNamed:@"ico_control_right"];
    self.theDirctionImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width - self.theDirctionImageView.frame.size.width / 2.0 - DSize(2), self.theControllDirctionView.frame.size.height / 2.0f);
  } else if (actionType == SDMoveDirctionDown) {
    self.theDirctionImageView.frame = CGRectMake(0, 0, DSize(190), DSize(80));
    self.theDirctionImageView.image = [PPImageUtil imageNamed:@"ico_control_down"];
    self.theDirctionImageView.center = CGPointMake(self.theControllDirctionView.frame.size.width / 2.0 + DSize(2), self.theControllDirctionView.frame.size.height - self.theDirctionImageView.frame.size.height / 2.0f - DSize(2));
  }
}
- (void)hideTouchDirctionView {
  [self.theDirctionImageView setHidden:true];
}
#pragma mark - SDSaintPushCoinViewDelegate
- (void)pushCoinWithCoinCount:(NSInteger)count {
    if ([PPGameConfig sharedInstance].autoPushCoin) {
        [self.arcadeCoinSubject sendNext:@(count)];
    }
    @synchronized (self) {
        if (self.had_fire_count == self.fire_count || self.had_fire_count > self.fire_count) {
            self.had_fire_count = 0;
            self.fire_count = count;
            [self delayFire];
        } else if (self.had_fire_count < self.fire_count) {
            self.fire_count += count;
        }
    }
}
#pragma mark - lazy UI
- (UIView * )theControllDirctionView{
  if (!_theControllDirctionView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(270));
      make.height.mas_equalTo(DSize(270));
      make.left.equalTo(self).offset(DSize(16));
      make.bottom.equalTo(self.mas_bottom).offset(DSize(-20));
    }];
    _theControllDirctionView = theView;
  }
  return _theControllDirctionView;
}
- (UIImageView * )theControllDirctionBgImageView{
  if (!_theControllDirctionBgImageView) {
      UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_new_control_bg"]];
    [self.theControllDirctionView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.theControllDirctionView);
    }];
    _theControllDirctionBgImageView = theView;
  }
  return _theControllDirctionBgImageView;
}
- (PPSaintGameControlButton * )theFireButton{
  if (!_theFireButton) {
    PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mas_right).offset(self.margin / 2.0);
      make.width.mas_equalTo(DSize(150));
      make.height.mas_equalTo(DSize(150));
      make.bottom.equalTo(self);
    }];
    theView.tag = 5;
    [theView showSaintShootBt];
    _theFireButton = theView;
  }
  return _theFireButton;
}
- (PPSaintGameControlButton * )theRaisebetButton{
  if (!_theRaisebetButton) {
    PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theFireButton.mas_centerX);
      make.width.mas_equalTo(DSize(91));
      make.height.mas_equalTo(DSize(91));
      make.bottom.equalTo(self.theFireButton.mas_top).offset(-DSize(40));
    }];
    theView.tag = 6;
    [theView showSaintRaisebetBt];
    _theRaisebetButton = theView;
  }
  return _theRaisebetButton;
}
- (PPSaintGameControlButton * )thePushCoinButton{
  if (!_thePushCoinButton) {
    PPSaintGameControlButton * theView = [[PPSaintGameControlButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theFireButton.mas_centerX);
      make.width.mas_equalTo(DSize(91));
      make.height.mas_equalTo(DSize(91));
      make.bottom.equalTo(self.theRaisebetButton.mas_top).offset(-DSize(40));
    }];
    theView.tag = 7;
    [theView showPushCoinBt];
    _thePushCoinButton = theView;
  }
  return _thePushCoinButton;
}
- (UIImageView*)thePointImageView {
  if (!_thePointImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_saint_dirction_point"]];
    [self.theControllDirctionView addSubview:theView];
    theView.frame = CGRectMake(0, 0, DSize(117), DSize(117));
      [theView setHidden:true];
    _thePointImageView = theView;
  }
  return _thePointImageView;
}
- (UIImageView * )theDirctionImageView {
  if (!_theDirctionImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theControllDirctionView addSubview:theView];
    [theView setHidden:true];
    _theDirctionImageView = theView;
  }
  return _theDirctionImageView;
}
- (PPSaintPushCoinView *)theSaintPushCoinView{
    if (!_theSaintPushCoinView) {
        PPSaintPushCoinView * theView = [[PPSaintPushCoinView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.thePushCoinButton.mas_left).offset(DSize(-30));
            make.top.equalTo(self.thePushCoinButton.mas_top);
            make.width.mas_equalTo(DSize(90));
            make.height.mas_equalTo(DSize(300));
        }];
        theView.pushCoinDelegate = self;
        [theView setHidden:true];
        _theSaintPushCoinView = theView;
    }
    return _theSaintPushCoinView;
}
- (SJPushCoinTagView *)pushCoinTagView{
    if (!_pushCoinTagView) {
        SJPushCoinTagView * theView = [[SJPushCoinTagView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thePushCoinButton.mas_right).offset(-DSize(10));
            make.bottom.equalTo(self.thePushCoinButton.mas_top).offset(DSize(10));
            make.width.mas_equalTo(DSize(40));
            make.height.mas_equalTo(DSize(40));
        }];
        [theView setHidden:true];
        _pushCoinTagView = theView;
    }
    return _pushCoinTagView;
}
@end
