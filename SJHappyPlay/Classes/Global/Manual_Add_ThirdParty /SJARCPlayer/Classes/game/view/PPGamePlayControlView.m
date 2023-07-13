#import "PPGamePlayControlView.h"
#import "AppDefineHeader.h"
#import "SJPlayActionButton.h"
#import "Masonry.h"
#import "SJPlayRetain.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPGamePlayControlView ()
@property (nonatomic, weak) SJPlayActionButton * theLeftBt;
@property (nonatomic, weak) SJPlayActionButton * theRightBt;
@property (nonatomic, weak) SJPlayActionButton * theUpBt;
@property (nonatomic, weak) SJPlayActionButton * theDownBt;
@property (nonatomic, weak) UIButton * theGradBt;
@property (nonatomic, weak) UILabel * theCountDownTimeLabel;
@property (nonatomic, strong) NSTimer * countDownTimer;
@end
@implementation PPGamePlayControlView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(288));
    [self configView];
  }
  return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self configView];
  }
  return self;
}
- (void)configView {
  [self theLeftBt];
  [self theUpBt];
  [self theDownBt];
  [self theRightBt];
  [self theGradBt];
}
#pragma mark - action
- (void)on_touch_long_start_action:(id)sender
{
  [self.longTouchActionSubject sendNext:sender];
}
- (void)on_touch_move_action:(id)sender
{
  [self.longTouchEndSubject sendNext:sender];
}
- (void)on_catch_action:(id)sender {
  [self.catchActionSubject sendNext:sender];
  [self stopWawajiGameCountDown];
}
- (void)repert_timer {
  self.countDownTime -= 1;
  if (self.countDownTime < 0) {
    self.countDownTime = 0;
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [[self catchActionSubject] sendNext:self.theGradBt];
  }
}
#pragma mark - public method
- (void)showCountDownInfo {
  self.theCountDownTimeLabel.hidden = false;
}
- (void)hideCounDownInfo {
  [self stopWawajiGameCountDown];
  self.theCountDownTimeLabel.hidden = true;
}
- (void)startWawajiGame {
  if (self.countDownTimer) {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
  }
  [self showCountDownInfo];
  self.countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(repert_timer) userInfo:nil repeats:true];
  [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
}
- (void)stopWawajiGameCountDown {
  [self.countDownTimer invalidate];
  self.countDownTime = 0;
}
#pragma mark - set
- (void)setCountDownTime:(NSInteger)countDownTime {
  _countDownTime = countDownTime;
  self.theCountDownTimeLabel.text = [NSString stringWithFormat:@"%lds", self.countDownTime];
}
#pragma mark - lazy UI
- (SJPlayActionButton * )theLeftBt{
  if (!_theLeftBt) {
    SJPlayActionButton * theView = [[SJPlayActionButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(SF_Float(67));
      make.top.equalTo(self).offset(SF_Float(70));
      make.width.mas_equalTo(SF_Float(102));
      make.height.mas_equalTo(SF_Float(81));
    }];
    theView.nomal_image = [PPImageUtil imageNamed:@"ico_play_left"];
    theView.selected_image = [PPImageUtil imageNamed:@"ico_play_left"];
    theView.disable_image = [PPImageUtil imageNamed:@"ico_play_left"];
    theView.custom_acceptEventInterval = 0.2;
    theView.tag = 3;
    [theView addTarget:self action:@selector(on_touch_long_start_action:) forControlEvents:UIControlEventTouchDown];
    [theView addTarget:self action:@selector(on_touch_move_action:) forControlEvents:UIControlEventTouchUpInside];
    _theLeftBt = theView;
  }
  return _theLeftBt;
}
- (SJPlayActionButton * )theUpBt{
  if (!_theUpBt) {
    SJPlayActionButton * theView = [[SJPlayActionButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(SF_Float(180));
      make.top.equalTo(self).offset(SF_Float(13));
      make.width.mas_equalTo(SF_Float(102));
      make.height.mas_equalTo(SF_Float(81));
    }];
    theView.nomal_image = [PPImageUtil imageNamed:@"ico_play_up"];
    theView.selected_image = [PPImageUtil imageNamed:@"ico_play_up"];
    theView.disable_image =  [PPImageUtil imageNamed:@"ico_play_up"];
    theView.custom_acceptEventInterval = 0.2;
    theView.tag = 1;
    [theView addTarget:self action:@selector(on_touch_long_start_action:) forControlEvents:UIControlEventTouchDown];
    [theView addTarget:self action:@selector(on_touch_move_action:) forControlEvents:UIControlEventTouchUpInside];
    _theUpBt = theView;
  }
  return _theUpBt;
}
- (SJPlayActionButton * )theRightBt{
  if (!_theRightBt) {
    SJPlayActionButton * theView = [[SJPlayActionButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(SF_Float(294));
      make.top.equalTo(self).offset(SF_Float(70));
      make.width.mas_equalTo(SF_Float(102));
      make.height.mas_equalTo(SF_Float(81));
    }];
    theView.nomal_image = [PPImageUtil imageNamed:@"ico_play_right"];
    theView.selected_image = [PPImageUtil imageNamed:@"ico_play_right"];
    theView.disable_image = [PPImageUtil imageNamed:@"ico_play_right"];
    theView.custom_acceptEventInterval = 0.2;
    [theView addTarget:self action:@selector(on_touch_long_start_action:) forControlEvents:UIControlEventTouchDown];
    [theView addTarget:self action:@selector(on_touch_move_action:) forControlEvents:UIControlEventTouchUpInside];
    theView.tag = 4;
    _theRightBt = theView;
  }
  return _theRightBt;
}
- (SJPlayActionButton * )theDownBt{
  if (!_theDownBt) {
    SJPlayActionButton * theView = [[SJPlayActionButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(SF_Float(180));
      make.top.equalTo(self).offset(SF_Float(128));
      make.width.mas_equalTo(SF_Float(102));
      make.height.mas_equalTo(SF_Float(81));
    }];
    theView.nomal_image = [PPImageUtil imageNamed:@"ico_play_down"];
    theView.selected_image = [PPImageUtil imageNamed:@"ico_play_down"];
    theView.disable_image = [PPImageUtil imageNamed:@"ico_play_down"];
    theView.custom_acceptEventInterval = 0.2;
    theView.tag = 2;
    [theView addTarget:self action:@selector(on_touch_long_start_action:) forControlEvents:UIControlEventTouchDown];
    [theView addTarget:self action:@selector(on_touch_move_action:) forControlEvents:UIControlEventTouchUpInside];
    _theDownBt = theView;
  }
  return _theDownBt;
}
- (UIButton * )theGradBt{
  if (!_theGradBt) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(SF_Float(30));
      make.right.equalTo(self.mas_right).offset(SF_Float(-70));
      make.width.mas_equalTo(SF_Float(175));
      make.height.mas_equalTo(SF_Float(135));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_play_grap"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(on_catch_action:) forControlEvents:UIControlEventTouchUpInside];
    _theGradBt = theView;
  }
  return _theGradBt;
}
- (UILabel * )theCountDownTimeLabel{
  if (!_theCountDownTimeLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
    theView.textColor = [UIColor colorForHex:@"#8E6733"];
      theView.font = AutoPxFont(30);
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(SF_Float(180));
      make.centerX.equalTo(self.theGradBt.mas_centerX);
    }];
    theView.hidden = true;
    _theCountDownTimeLabel = theView;
  }
  return _theCountDownTimeLabel;
}
@end
