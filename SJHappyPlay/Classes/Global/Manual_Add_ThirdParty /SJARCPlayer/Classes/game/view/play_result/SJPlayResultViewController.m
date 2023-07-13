#import "SJPlayResultViewController.h"
#import "PPOutlineLabel.h"
#import "PPOutLineButton.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIImageView+WebCache.h"
#import "PPGameFailResultView.h"
#import "PPGameSuccessResultView.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface SJPlayResultViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView * theBgView;
@property (nonatomic, strong) NSTimer * runTimer;
@property (nonatomic, assign) NSInteger current_time;
@property (nonatomic, weak) PPGameFailResultView * gameFailResultView;
@property (nonatomic, weak) UIButton * thePlayAnginButton;
@property (nonatomic, weak) UIButton * theCloseButton;
@property (nonatomic, weak) PPGameSuccessResultView * gameSuccessResultView;
@end
@implementation SJPlayResultViewController
- (void)viewDidLoad {
  [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
  [self sd_configView];
  [self sd_configData];
}
- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)sd_configView
{
  UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(on_disMissResultView:)];
  tap.delegate = self;
  [self.view addGestureRecognizer:tap];
  [self gameFailResultView].hidden = true;
  [self gameSuccessResultView].hidden = true;
  [self theCloseButton];
  if (self.isOtherPlay) {
    [self thePlayAnginButton].hidden = true;
    [self performSelector:@selector(onDismissAutoPress) withObject:nil afterDelay:3];
  }else {
    [self thePlayAnginButton].hidden = false;
  }
}
- (void)sd_configData
{
  if (self.value == 1) {
    if (self.isOtherPlay) {
      if (self.type == 1) {
        self.gameSuccessResultView.hidden = false;
        self.gameSuccessResultView.game_win_image_url = self.game_win_image_url;
        self.gameSuccessResultView.value = self.value;
        self.gameSuccessResultView.type = self.type;
        self.gameSuccessResultView.game_win_image_url = self.game_win_image_url;
        self.gameSuccessResultView.ballNum = self.ballNum;
        [self.gameSuccessResultView displayView];
        [self.gameSuccessResultView displayOtherPlay];
      }else {
        [self gameFailResultView].hidden = false;
        self.thePlayAnginButton.center = CGPointMake(CGRectGetMidX(self.gameFailResultView.frame), CGRectGetMaxY(self.gameFailResultView.frame) + self.thePlayAnginButton.frame.size.height / 2.0f + DSize(10));
        self.gameFailResultView.titleStr = @"";
        self.gameFailResultView.theRewardLogoImage = nil;
        self.gameFailResultView.ballNum = self.ballNum;
        if (self.level) {
          self.gameFailResultView.level = [self.level intValue];
        }else {
          self.gameFailResultView.level = -1;
        }
      }
      return;
    }else {
      if (self.type == 1) {
        [self gameSuccessResultView].hidden = false;
        self.thePlayAnginButton.center = CGPointMake(CGRectGetMidX(self.gameSuccessResultView.frame), CGRectGetMaxY(self.gameSuccessResultView.frame) + self.thePlayAnginButton.frame.size.height / 2.0f + DSize(10));
        self.gameSuccessResultView.hidden = false;
        self.gameSuccessResultView.game_win_image_url = self.game_win_image_url;
        self.gameSuccessResultView.value = self.value;
        self.gameSuccessResultView.type = self.type;
        self.gameSuccessResultView.game_win_image_url = self.game_win_image_url;
        self.gameSuccessResultView.ballNum = self.ballNum;
        [self.gameSuccessResultView displayView];
        [self start_run_down_time];
        return;
      }
    }
    if (self.level) {
      NSInteger levelVue = [self.level intValue];
      [self gameSuccessResultView].hidden = false;
      self.thePlayAnginButton.center = CGPointMake(CGRectGetMidX(self.gameSuccessResultView.frame), CGRectGetMaxY(self.gameSuccessResultView.frame) + self.thePlayAnginButton.frame.size.height / 2.0f + DSize(10));
      self.gameSuccessResultView.value = self.value;
      self.gameSuccessResultView.type = self.type;
      self.gameSuccessResultView.level = levelVue;
      self.gameSuccessResultView.game_win_image_url = self.game_win_image_url;
      self.gameSuccessResultView.ballNum = self.ballNum;
      [self.gameSuccessResultView displayView];
      if (self.isOtherPlay) {
        [self.gameSuccessResultView displayOtherPlay];
      }
    }else {
      [self gameFailResultView].hidden = false;
      self.thePlayAnginButton.center = CGPointMake(CGRectGetMidX(self.gameFailResultView.frame), CGRectGetMaxY(self.gameFailResultView.frame) + self.thePlayAnginButton.frame.size.height / 2.0f + DSize(10));
      self.gameFailResultView.titleStr = [NSString stringWithFormat:@"恭喜你！抓中%ld号球，\n请等待开奖",self.ballNum];
      self.gameFailResultView.theRewardLogoImage = [PPImageUtil imageNamed:@"ico_reward_te"];
    }
  }else{
    [self gameFailResultView].hidden = false;
    self.theCloseButton.hidden = false;
    self.thePlayAnginButton.center = CGPointMake(CGRectGetMidX(self.gameFailResultView.frame), CGRectGetMaxY(self.gameFailResultView.frame) + self.thePlayAnginButton.frame.size.height / 2.0f + DSize(10));
  }
  [self start_run_down_time];
}
- (void)start_run_down_time
{
  if (self.runTimer) {
    [self.runTimer invalidate];
    self.runTimer = nil;
  }
  self.runTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(down_run_time) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.runTimer forMode:NSDefaultRunLoopMode];
  self.current_time = self.protection_seconds;
}
- (void)stop_run_down_time
{
  if (self.runTimer) {
    [self.runTimer invalidate];
    self.runTimer = nil;
  }
}
#pragma mark - action
- (void)on_disMissResultView:(UIGestureRecognizer * )gesture
{
  [self stop_run_down_time];
  [UIView animateWithDuration:0.3 animations:^{
    self.view.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    if (finished) {
      [self dismissViewControllerAnimated:NO completion:^{
      }];
    }
  }];
}
- (void)onDismissAutoPress{
  [self on_disMissResultView:nil];
}
- (void)down_run_time
{
  self.current_time -= 1;
  if (self.current_time < 0) {
    self.current_time =0;
    [self stop_run_down_time];
  }
}
- (void)setCurrent_time:(NSInteger)current_time
{
  _current_time = current_time;
  NSString * buttonTitle = [NSString stringWithFormat:@"继续挑战(%lds)",current_time];
  if (_current_time == 0) {
    buttonTitle = @"继续挑战";
  }
  [self.thePlayAnginButton setTitle:buttonTitle forState:UIControlStateNormal];
}
- (void)on_recharge_action:(id)sender
{
}
- (void)on_retain_start_game:(id)sender
{
  [self stop_run_down_time];
  [UIView animateWithDuration:0.3 animations:^{
    self.view.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    if (finished) {
      [self dismissViewControllerAnimated:NO completion:^{
        if (self.playResultAction) {
          if (self.current_time > 0) {
            self.playResultAction(1);
          }else {
            self.playResultAction(2);
          }
        }
      }];
    }
  }];
}
- (void)on_close_action:(id)sender
{
  [self on_disMissResultView:nil];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isKindOfClass:[UIControl class]]) {
    return NO;
  }
  return YES;
}
#pragma mark - lazy
- (PPGameFailResultView *)gameFailResultView{
  if (!_gameFailResultView) {
    PPGameFailResultView * theView = [[PPGameFailResultView alloc] init];
    [self.view addSubview:theView];
    theView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height/2.0f);
    _gameFailResultView = theView;
  }
  return _gameFailResultView;
}
- (UIButton *)thePlayAnginButton{
  if (!_thePlayAnginButton) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DSize(281), DSize(80))];
    [self.view addSubview:theView];
    theView.backgroundColor = [UIColor colorForHex:@"#FAD92A"];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(40);
    [theView setTitle:@"继续挑战" forState:UIControlStateNormal];
    [theView setTitleColor:[UIColor colorForHex:@"#C77000"] forState:UIControlStateNormal];
      theView.titleLabel.font = AutoPxFont(28);
    [theView addTarget:self action:@selector(on_retain_start_game:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayAnginButton = theView;
  }
  return _thePlayAnginButton;
}
- (PPGameSuccessResultView *)gameSuccessResultView{
  if (!_gameSuccessResultView) {
    PPGameSuccessResultView * theView = [[PPGameSuccessResultView alloc] init];
    [self.view addSubview:theView];
    theView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    _gameSuccessResultView = theView;
  }
  return _gameSuccessResultView;
}
- (UIButton *)theCloseButton
{
  if (!_theCloseButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.gameFailResultView);
      make.right.equalTo(self.gameFailResultView);
      make.width.and.height.mas_equalTo(DSize(50));
    }];
    theView.hidden = true;
    [theView setImage:[PPImageUtil imageNamed:@"ico_close"] forState:UIControlStateNormal];
    [theView addTarget:self
                action:@selector(on_close_action:) forControlEvents:UIControlEventTouchUpInside];
    _theCloseButton = theView;
  }
  return _theCloseButton;
}
@end
