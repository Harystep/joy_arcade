#import "PPSaintGameControlButton.h"
#import "PPThread.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "POP.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPSaintGameControlButton ()
@property (nonatomic, strong) PPThread * touchThread;
@property (nonatomic, assign) BOOL hadRunTouchDown;
@property (nonatomic, weak) UIImageView * theActionLogoImageView;
@property (nonatomic, weak) UILabel * theActionLabel;
@end
@implementation PPSaintGameControlButton
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configData];
  }
  return self;
}
#pragma mark - config
- (void)configData {
  self.touchSubject = [RACSubject subject];
  self.touchThread = [PPThread currentSDThread:1];
  [self addTarget:self action:@selector(onTouchBagainPress:) forControlEvents:UIControlEventTouchDown];
  [self addTarget:self action:@selector(onTouchEndPress:) forControlEvents:UIControlEventTouchUpInside];
  [self addTarget:self action:@selector(onTouchEndPress:) forControlEvents:UIControlEventTouchCancel];
  [self addTarget:self action:@selector(onTouchEndPress:) forControlEvents:UIControlEventTouchUpOutside];
}
- (void)layoutSubviews{
  [super layoutSubviews];
  self.theActionLogoImageView.frame = self.theControlBgView.bounds;
}
#pragma mark - public method
- (void)showSaintShootBt {
  [self theControlBgView];
  self.actionLogoImage = [PPImageUtil imageNamed:@"ico_saint_fire"];
}
- (void)showSaintRaisebetBt {
  [self theControlBgView];
  self.actionLogoImage = [PPImageUtil imageNamed:@"ico_saint_fire_double_bt"];
}
- (void)showPushCoinBt {
  [self theControlBgView];
  self.actionLogoImage = [PPImageUtil imageNamed:@"ico_saint_push_coin_bt"];
}
#pragma mark - set
- (void)setActionLogoImage:(UIImage *)actionLogoImage {
  _actionLogoImage = actionLogoImage;
  self.theActionLogoImageView.image = self.actionLogoImage;
}
#pragma mark - action
- (void)onTapPress:(UIGestureRecognizer *)gesture {
  NSLog(@"[on tap Press] ----> %ld",gesture.state);
  if (gesture.state == UIGestureRecognizerStateBegan) {
    [self onTouchBagainPress:nil];
  } else {
    [self onTouchEndPress:nil];
  }
}
- (void)afterRunTouchBagin{
  @weakify_self;
  [self.touchThread delay:0.2 runBlock:^{
    @strongify_self;
    self.hadRunTouchDown = true;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.touchSubject sendNext:@(ControlTouchDown)];
    });
  }];
}
- (void)onTouchBagainPress:(id)sender {
  self.hadRunTouchDown = false;
  [self afterRunTouchBagin];
  POPBasicAnimation * bigAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
  bigAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2, 1.2)];
  bigAnimation.duration = 0.3;
  [self.theActionLogoImageView pop_addAnimation:bigAnimation forKey:@"big_animtion"];
}
- (void)onTouchEndPress:(id)sender {
  [self.touchThread interrupt];
  if (self.hadRunTouchDown) {
    [self.touchSubject sendNext:@(ControlTouchUp)];
  } else {
    [self.touchSubject sendNext:@(ControlTouchSimple)];
  }
  POPBasicAnimation * smailAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
  smailAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
  smailAnimation.duration = 0.3;
  [self.theActionLogoImageView pop_addAnimation:smailAnimation forKey:@"smailAnimation"];
}
#pragma mark - lazy UI
- (UIView * )theControlBgView{
  if (!_theControlBgView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    theView.backgroundColor = [UIColor clearColor];
    theView.userInteractionEnabled = false;
    _theControlBgView = theView;
  }
  return _theControlBgView;
}
- (UIImageView * )theActionLogoImageView{
  if (!_theActionLogoImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.theControlBgView addSubview:theView];
    theView.userInteractionEnabled = false;
    _theActionLogoImageView = theView;
  }
  return _theActionLogoImageView;
}
- (UILabel * )theActionLabel{
  if (!_theActionLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theControlBgView addSubview:theView];
      theView.font = AutoPxFont(18);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theControlBgView);
      make.top.equalTo(self.theActionLogoImageView.mas_bottom).offset(DSize(2));
    }];
    _theActionLabel = theView;
  }
  return _theActionLabel;
}
@end
