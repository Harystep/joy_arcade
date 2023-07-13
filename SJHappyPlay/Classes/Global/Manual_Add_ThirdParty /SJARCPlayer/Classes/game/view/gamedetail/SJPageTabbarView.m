#import "SJPageTabbarView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"

#import "AppDefineHeader.h"

@interface SJPageTabbarView ()
@property (nonatomic, weak) UIView * theBottomLineView;
@property (nonatomic, strong) NSArray * theTabViewList;
@end
@implementation SJPageTabbarView
- (instancetype)initWithTab:(NSArray <NSString * > * ) list
{
  self = [super init];
  if (self) {
    _tabList = list;
    _currentTab = 0;
    self.tabSubject = [RACSubject subject];
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(100));
  NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
  for (NSInteger i = 0; i < self.tabList.count; i ++ ) {
    [list addObject:[self createTabButtonView:i]];
  }
  self.theTabViewList = [list copy];
  self.theBottomLineView.frame = CGRectMake(SCREEN_WIDTH / 4.0 - SF_Float(61), SF_Float(95), SF_Float(122), SF_Float(8));
}
- (UIButton * )createTabButtonView:(NSInteger)tag {
  UIButton * theView = [[UIButton alloc] initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 2.0 * tag, 0, SCREEN_WIDTH / 2.f, SF_Float(100))];
  [self addSubview:theView];
  NSString * tab = self.tabList[tag];
  [theView setTitle:tab forState:UIControlStateNormal];
  theView.backgroundColor = [UIColor clearColor];
  [theView setTitleColor:[UIColor colorForHex:@"#888888"] forState:UIControlStateNormal];
  [theView setTitleColor:[UIColor colorForHex:@"#111111"] forState:UIControlStateSelected];
    theView.titleLabel.font = AutoPxFont(30);
  theView.selected = self.currentTab == tag;
  [theView addTarget:self action:@selector(onselectedTabBarPress:) forControlEvents:UIControlEventTouchUpInside];
  theView.tag = tag;
  return theView;
}
#pragma mark - set
- (void)setCurrentTab:(NSInteger)currentTab {
  _currentTab = currentTab;
  for (UIButton * bt in self.theTabViewList) {
    bt.selected = false;
  }
  UIButton * selectedBt = self.theTabViewList[self.currentTab];
  selectedBt.selected = true;
  self.theBottomLineView.frame = CGRectMake(SCREEN_WIDTH / 4.0 - SF_Float(61) + SCREEN_WIDTH / 2.0 * currentTab, SF_Float(95), SF_Float(122), SF_Float(8));
}
#pragma mark - action
- (void)onselectedTabBarPress:(id)sender {
  UIButton * bt = sender;
  self.currentTab = bt.tag;
  [self.tabSubject sendNext:@(self.currentTab)];
}
#pragma mark - lazy UI
- (UIView * )theBottomLineView{
  if (!_theBottomLineView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    theView.backgroundColor = [UIColor colorForHex:@"#FAE55E"];
    _theBottomLineView = theView;
  }
  return _theBottomLineView;
}
@end
