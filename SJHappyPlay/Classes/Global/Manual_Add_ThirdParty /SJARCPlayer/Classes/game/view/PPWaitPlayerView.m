#import "PPWaitPlayerView.h"
#import "PPNetworkStatusView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "SJPlayerAvatarView.h"
#import "AppDefineHeader.h"
@interface PPWaitPlayerView ()
@property (nonatomic, weak) PPNetworkStatusView * theNetworkStatusView;
@property (nonatomic, weak) UILabel * theWaitPlayerLabel;
@property (nonatomic, strong) NSMutableArray * waitPlayerViewList;
@end
@implementation PPWaitPlayerView
- (instancetype)initWithShowQuality:(BOOL)show
{
  self = [super init];
  if (self) {
    _showQuality = show;
    [self configView];
  }
  return self;
}
- (instancetype)initWithFrame:(CGRect)frame withShowQuality:(BOOL)show
{
  self = [super initWithFrame:frame];
  if (self) {
    _showQuality = show;
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  self.waitPlayerViewList = [NSMutableArray arrayWithCapacity:0];
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
  self.layer.masksToBounds = true;
  self.layer.cornerRadius = self.bounds.size.height / 2.0f;
  if (self.showQuality) {
    [self theNetworkStatusView];
  }
  self.theWaitPlayerLabel.text = @"0人\n等待";
}
#pragma mark - set
- (void)setWaitPlayerList:(NSArray<SDPlayerInfoModel *> *)waitPlayerList {
  _waitPlayerList = waitPlayerList;
  [self.waitPlayerViewList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[UIView class]]) {
      UIView * view = obj;
      [view removeFromSuperview];
    }
  }];
  [self.waitPlayerViewList removeAllObjects];
  self.theWaitPlayerLabel.text = [NSString stringWithFormat:@"%ld人\n等待", self.waitMemberCount];
  CGSize waitPlayerSize = [self.theWaitPlayerLabel.text sizeWithAttributes:@{NSFontAttributeName: self.theWaitPlayerLabel.font}];
  [self.theWaitPlayerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(waitPlayerSize.width);
    if (self.showQuality) {
      make.right.equalTo(self).offset(-DSize(99));
    } else {
      make.right.equalTo(self).offset(-DSize(20));
    }
  }];
  [self.waitPlayerList enumerateObjectsUsingBlock:^(SDPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (idx < 4) {
      SJPlayerAvatarView * avatarView = [self createAvatarPlayerView:obj];
      [self addSubview:avatarView];
      avatarView.frame = CGRectMake(DSize(10) + DSize(44) * idx, DSize(10), avatarView.frame.size.width, avatarView.frame.size.height);
      [self.waitPlayerViewList addObject:avatarView];
    }
  }];
  if (self.waitPlayerViewList.count > 0) {
    SJPlayerAvatarView * theLastView = self.waitPlayerViewList.lastObject;
    CGFloat maxWidth = CGRectGetMaxX(theLastView.frame);
    maxWidth += DSize(10);
    maxWidth += waitPlayerSize.width;
    if (self.showQuality) {
      maxWidth += DSize(10);
      maxWidth += DSize(90);
    } else {
      maxWidth += DSize(20);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, self.frame.size.height);
  }
}
- (void)setWaitMemberCount:(NSInteger)waitMemberCount {
  _waitMemberCount = waitMemberCount;
  self.theWaitPlayerLabel.text = [NSString stringWithFormat:@"%ld人\n等待", self.waitMemberCount];
  CGSize waitPlayerSize = [self.theWaitPlayerLabel.text sizeWithAttributes:@{NSFontAttributeName: self.theWaitPlayerLabel.font}];
  [self.theWaitPlayerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(waitPlayerSize.width);
    if (self.showQuality) {
      make.right.equalTo(self).offset(-DSize(99));
    } else {
      make.right.equalTo(self).offset(-DSize(20));
    }
  }];
  if (self.waitPlayerViewList.count > 0) {
    SJPlayerAvatarView * theLastView = self.waitPlayerViewList.lastObject;
    CGFloat maxWidth = CGRectGetMaxX(theLastView.frame);
    maxWidth += DSize(10);
    maxWidth += waitPlayerSize.width;
    if (self.showQuality) {
      maxWidth += DSize(10);
      maxWidth += DSize(90);
    } else {
      maxWidth += DSize(20);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, self.frame.size.height);
  }
}
- (SJPlayerAvatarView * )createAvatarPlayerView:(SDPlayerInfoModel * )playInfo {
  SJPlayerAvatarView * playerAvatarView = [[SJPlayerAvatarView alloc] initWithSize:DSize(52)];
  playerAvatarView.avatarUrl = playInfo.avatar;
  return playerAvatarView;
}
#pragma mark - lazy UI
- (PPNetworkStatusView * )theNetworkStatusView{
  if (!_theNetworkStatusView) {
    PPNetworkStatusView * theView = [[PPNetworkStatusView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-DSize(10));
      make.centerY.equalTo(self);
      make.size.mas_equalTo(theView.frame.size);
    }];
    _theNetworkStatusView = theView;
  }
  return _theNetworkStatusView;
}
- (UILabel * )theWaitPlayerLabel{
  if (!_theWaitPlayerLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self addSubview:theView];
      theView.font = AutoPxFont(18);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.height.mas_equalTo(DSize(48));
      make.right.equalTo(self).offset(-DSize(99));
      make.width.mas_equalTo(0);
    }];
    theView.numberOfLines = 2;
    _theWaitPlayerLabel = theView;
  }
  return _theWaitPlayerLabel;
}
@end
