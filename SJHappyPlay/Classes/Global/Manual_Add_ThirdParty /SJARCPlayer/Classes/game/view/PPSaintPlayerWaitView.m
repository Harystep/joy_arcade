#import "PPSaintPlayerWaitView.h"
#import "AppDefineHeader.h"
#import "PPImageUtil.h"
#import "AppDefineHeader.h"


@interface PPSaintPlayerWaitView ()
@property (nonatomic, weak) UIButton * thePlayer1Button;
@property (nonatomic, weak) UIButton * thePlayer2Button;
@property (nonatomic, weak) UIButton * thePlayer3Button;
@property (nonatomic, weak) UIButton * thePlayer4Button;
@end
@implementation PPSaintPlayerWaitView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, DSize(100));
    self.playerDoneSubject = [RACSubject subject];
    [self configView];
  }
  return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.playerDoneSubject = [RACSubject subject];
    [self configView];
  }
  return self;
}
- (void)configView {
  [self thePlayer1Button];
  [self thePlayer2Button];
  [self thePlayer3Button];
  [self thePlayer4Button];
}
#pragma mark - set
- (void)setPlayerList:(NSArray<SDSaintSeatInfoModel *> *)playerList {
  _playerList = playerList;
  self.thePlayer1Button.hidden = false;
  self.thePlayer2Button.hidden = false;
  self.thePlayer3Button.hidden = false;
  self.thePlayer4Button.hidden = false;
  for (SDSaintSeatInfoModel * seatInfo in self.playerList) {
    if (seatInfo.position == 1) {
      self.thePlayer1Button.hidden = true;
    } else if (seatInfo.position == 2) {
      self.thePlayer2Button.hidden = true;
    } else if (seatInfo.position == 3) {
      self.thePlayer3Button.hidden = true;
    } else if (seatInfo.position == 4) {
      self.thePlayer4Button.hidden = true;
    }
  }
}
#pragma mark - action
- (void)onTapPerchSaintPlayerPress:(id)sender {
  UIButton * bt = (UIButton *)sender;
  if (self.playerDoneSubject) {
    [self.playerDoneSubject sendNext:@(bt.tag)];
  }
}
#pragma mark - lazy UI
- (UIButton * )thePlayer1Button{
  if (!_thePlayer1Button) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(195 / 1920.0 * self.bounds.size.width, 0, DSize(140), DSize(60))];
    [self addSubview:theView];
    [theView setImage:[PPImageUtil imageNamed:@"img_jj_roler_1_a"] forState:UIControlStateNormal];
    theView.tag = 1;
    [theView addTarget:self action:@selector(onTapPerchSaintPlayerPress:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayer1Button = theView;
  }
  return _thePlayer1Button;
}
- (UIButton * )thePlayer2Button{
  if (!_thePlayer2Button) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(666 / 1920.0 * self.bounds.size.width, 0, DSize(140), DSize(60))];
    [self addSubview:theView];
    [theView setImage:[PPImageUtil imageNamed:@"img_jj_roler_2_a"] forState:UIControlStateNormal];
    theView.tag = 2;
    [theView addTarget:self action:@selector(onTapPerchSaintPlayerPress:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayer2Button = theView;
  }
  return _thePlayer2Button;
}
- (UIButton * )thePlayer3Button{
  if (!_thePlayer3Button) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(1150 / 1920.0 * self.bounds.size.width, 0, DSize(140), DSize(60))];
    [self addSubview:theView];
    theView.tag = 3;
    [theView setImage:[PPImageUtil imageNamed:@"img_jj_roler_3_a"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onTapPerchSaintPlayerPress:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayer3Button = theView;
  }
  return _thePlayer3Button;
}
- (UIButton * )thePlayer4Button{
  if (!_thePlayer4Button) {
    UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(1640 / 1920.0 * self.bounds.size.width, 0, DSize(140), DSize(60))];
    [self addSubview:theView];
    theView.tag = 4;
    [theView setImage:[PPImageUtil imageNamed:@"img_jj_roler_4_a"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onTapPerchSaintPlayerPress:) forControlEvents:UIControlEventTouchUpInside];
    _thePlayer4Button = theView;
  }
  return _thePlayer4Button;
}
@end
