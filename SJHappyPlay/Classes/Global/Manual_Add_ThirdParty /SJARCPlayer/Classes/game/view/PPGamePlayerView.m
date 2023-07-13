#import "PPGamePlayerView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "SJPlayerAvatarView.h"
#import "PPNetworkStatusView.h"
#import "POP.h"
#import "PPWaitPlayerView.h"

#import "AppDefineHeader.h"

@interface PPGamePlayerView ()
@property (nonatomic, weak) UIView * thePlayeringView;
@property (nonatomic, weak) SJPlayerAvatarView * thePlayingAvatarImageView;
@property (nonatomic, weak) UILabel * thePlayingUserNameLabel;
@property (nonatomic, weak) UILabel * thePlayingStatusLabel;
@property (nonatomic, strong) NSMutableArray * waitPlayerViewList;
@property (nonatomic, weak) PPWaitPlayerView * theWaitPlayerView;
@end
@implementation PPGamePlayerView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(730), SF_Float(72));
    self.waitPlayerViewList = [NSMutableArray arrayWithCapacity:0];
    [self configView];
  }
  return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.waitPlayerViewList = [NSMutableArray arrayWithCapacity:0];
    [self configView];
  }
  return self;
}
- (void)configView {
  [self thePlayeringView];
  [self thePlayingAvatarImageView];
  [self thePlayingUserNameLabel];
  [self thePlayingStatusLabel];
  [self theWaitPlayerView];
}
- (void)setCurrentPlayer:(SDPlayerInfoModel *)currentPlayer {
  _currentPlayer = currentPlayer;
  if (self.currentPlayer) {
    self.thePlayingUserNameLabel.text = self.currentPlayer.nickname;
    self.thePlayingAvatarImageView.avatarUrl = self.currentPlayer.avatar;
    POPBasicAnimation * showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.toValue = @(1);
    [self.thePlayeringView pop_addAnimation:showAnimation forKey:@"show_animation"];
    POPSpringAnimation * moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGRect waitPlayerFrame = CGRectMake(self.bounds.size.width - self.theWaitPlayerView.frame.size.width - SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    moveAnimation.toValue = [NSValue valueWithCGRect: waitPlayerFrame];
    [self.theWaitPlayerView pop_addAnimation:moveAnimation forKey:@"move_animtaion"];
  } else {
    POPBasicAnimation * showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.toValue = @(0);
    [self.thePlayeringView pop_addAnimation:showAnimation forKey:@"hide_animation"];
    POPSpringAnimation * moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGRect waitPlayerFrame = CGRectMake(SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    moveAnimation.toValue = [NSValue valueWithCGRect: waitPlayerFrame];
    [self.theWaitPlayerView pop_addAnimation:moveAnimation forKey:@"move_animtaion"];
  }
}
- (void)setWaitPlayerList:(NSArray<SDPlayerInfoModel *> *)waitPlayerList {
  _waitPlayerList = waitPlayerList;
  self.theWaitPlayerView.waitPlayerList = self.waitPlayerList;
  if (self.waitPlayerList.count > 0) {
    if (self.currentPlayer) {
      self.theWaitPlayerView.frame = CGRectMake(self.bounds.size.width - self.theWaitPlayerView.frame.size.width - SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    } else {
      self.theWaitPlayerView.frame = CGRectMake(SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    }
      [self.theWaitPlayerView setHidden:false];
  }
}
- (void)setWaitMemberCount:(NSInteger)waitMemberCount {
  _waitMemberCount = waitMemberCount;
  self.theWaitPlayerView.waitMemberCount = self.waitMemberCount;
  if (self.waitPlayerList.count > 0) {
    if (self.currentPlayer) {
      self.theWaitPlayerView.frame = CGRectMake(self.bounds.size.width - self.theWaitPlayerView.frame.size.width - SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    } else {
      self.theWaitPlayerView.frame = CGRectMake(SF_Float(20), self.theWaitPlayerView.frame.origin.y, self.theWaitPlayerView.frame.size.width, self.theWaitPlayerView.frame.size.height);
    }
      [self.theWaitPlayerView setHidden:false];
  }
}
- (SJPlayerAvatarView * )createAvatarPlayerView:(SDPlayerInfoModel * )playInfo {
  SJPlayerAvatarView * playerAvatarView = [[SJPlayerAvatarView alloc] initWithSize:SF_Float(52)];
  playerAvatarView.avatarUrl = playInfo.avatar;
  return playerAvatarView;
}
#pragma mark - lazy UI
- (UIView * )thePlayeringView{
  if (!_thePlayeringView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(292));
      make.height.mas_equalTo(SF_Float(72));
      make.centerY.equalTo(self);
      make.left.equalTo(self).offset(SF_Float(20));
    }];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(36);
    theView.alpha = 0;
    _thePlayeringView = theView;
  }
  return _thePlayeringView;
}
- (SJPlayerAvatarView * )thePlayingAvatarImageView{
  if (!_thePlayingAvatarImageView) {
    SJPlayerAvatarView * theView = [[SJPlayerAvatarView alloc] initWithSize:SF_Float(72)];
    [self.thePlayeringView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.thePlayeringView);
      make.top.equalTo(self.thePlayeringView);
      make.size.mas_equalTo(theView.frame.size);
    }];
    _thePlayingAvatarImageView = theView;
  }
  return _thePlayingAvatarImageView;
}
- (UILabel * )thePlayingUserNameLabel{
  if (!_thePlayingUserNameLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayeringView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.thePlayingAvatarImageView.mas_right).offset(SF_Float(16));
      make.bottom.equalTo(self.thePlayeringView.mas_centerY).offset(-SF_Float(2.5));
        make.width.mas_equalTo(SF_Float(90));
    }];
      theView.font = AutoPxFont(26);
    theView.textColor = [UIColor whiteColor];
    _thePlayingUserNameLabel = theView;
  }
  return _thePlayingUserNameLabel;
}
- (UILabel * )thePlayingStatusLabel{
  if (!_thePlayingStatusLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayeringView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.thePlayingAvatarImageView.mas_right).offset(SF_Float(16));
      make.top.equalTo(self.thePlayeringView.mas_centerY).offset(SF_Float(2.5));
    }];
      theView.font = AutoPxFont(24);
    theView.textColor = [UIColor colorForHex:@"#FF94C0"];
    theView.text = @"正在游戏中...";
    _thePlayingStatusLabel = theView;
  }
  return _thePlayingStatusLabel;
}
- (PPWaitPlayerView * )theWaitPlayerView{
  if (!_theWaitPlayerView) {
    PPWaitPlayerView * theView = [[PPWaitPlayerView alloc] initWithFrame:CGRectMake(self.bounds.size.width - SF_Float(218), 0, SF_Float(298), SF_Float(72)) withShowQuality:true];
    [self addSubview:theView];
      theView.hidden = true;
    _theWaitPlayerView = theView;
  }
  return _theWaitPlayerView;
}
@end
