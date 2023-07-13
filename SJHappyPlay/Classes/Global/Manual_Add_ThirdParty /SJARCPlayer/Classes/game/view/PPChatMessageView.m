#import "PPChatMessageView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPChatMessageTableViewCell.h"
#import "PPChatMessageDataModel.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPChatMessageView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIButton * theShowOrHideView;
@property (nonatomic, weak) UIButton * theInputChatMessageButton;
@property (nonatomic, assign) BOOL isShowChatMessage;
@property (nonatomic, weak) UITableView * theTableView;
@property (nonatomic, strong) NSMutableArray<PPChatMessageDataModel *> * tableList;
@end
@implementation PPChatMessageView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(388), SF_Float(276));
    self.isShowChatMessage = true;
    self.tableList = [NSMutableArray arrayWithCapacity:0];
    self.inputChatSubject = [RACSubject subject];
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self theShowOrHideView];
  [self theTableView];
  self.inputChatHidden = true;
}
#pragma mark - set
- (void)setInputChatHidden:(BOOL)inputChatHidden {
  _inputChatHidden = inputChatHidden;
  self.theInputChatMessageButton.hidden = self.inputChatHidden;
}
- (void)setIsShowChatMessage:(BOOL)isShowChatMessage {
  _isShowChatMessage = isShowChatMessage;
  [self.theTableView setHidden:!self.isShowChatMessage];
}
#pragma mark - public method
- (void)insertChatMessage:(PPChatMessageDataModel * )chatModel{
  [chatModel configChatMessage];
  [self.tableList addObject:chatModel];
  [self.theTableView reloadData];
  CGPoint offset =CGPointMake(0,self.theTableView.contentSize.height - self.theTableView.frame.size.height);
  [self.theTableView setContentOffset:offset animated:true];
}
#pragma mark - action
- (void)onShowOrHidePress:(id)sender {
  self.isShowChatMessage = !self.isShowChatMessage;
  if (self.isShowChatMessage) {
    self.theShowOrHideView.imageView.transform = CGAffineTransformIdentity;
  } else {
    self.theShowOrHideView.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
  }
}
- (void)onInputChatPress:(id)sender {
  [self.inputChatSubject sendNext:sender];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tableList.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPChatMessageDataModel * model = self.tableList[indexPath.row];
  PPChatMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[model CellIdentifier]];
  [cell loadHomeDataModel:model];
  return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPChatMessageDataModel * model = self.tableList[indexPath.row];
  return model.hegiht_size_cell;
}
#pragma mark - lazy UI
- (UIButton * )theShowOrHideView{
  if (!_theShowOrHideView) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView setImage:[PPImageUtil imageNamed:@"ico_white_point"] forState:UIControlStateNormal];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(58));
      make.height.mas_equalTo(SF_Float(36));
      make.left.equalTo(self);
      make.bottom.equalTo(self);
    }];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(18);
    [theView addTarget:self action:@selector(onShowOrHidePress:) forControlEvents:UIControlEventTouchUpInside];
    _theShowOrHideView = theView;
  }
  return _theShowOrHideView;
}
- (UIButton * )theInputChatMessageButton{
  if (!_theInputChatMessageButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView setImage:[PPImageUtil imageNamed:@"ico_input_mesasge"] forState:UIControlStateNormal];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(SF_Float(58));
      make.height.mas_equalTo(SF_Float(36));
      make.left.equalTo(self.theShowOrHideView.mas_right).offset(SF_Float(10));
      make.centerY.equalTo(self.theShowOrHideView.mas_centerY);
    }];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(18);
    [theView addTarget:self action:@selector(onInputChatPress:) forControlEvents:UIControlEventTouchUpInside];
    _theInputChatMessageButton = theView;
  }
  return _theInputChatMessageButton;
}
- (UITableView * )theTableView{
  if (!_theTableView) {
    UITableView * theView = [[UITableView alloc] init];
    [self addSubview:theView];
    [theView registerClass:[PPChatMessageTableViewCell class] forCellReuseIdentifier:[PPChatMessageTableViewCell getCellIdentifier]];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self);
      make.left.equalTo(self);
      make.right.equalTo(self);
      make.bottom.equalTo(self.theShowOrHideView.mas_top).offset(-SF_Float(10));
    }];
    theView.separatorStyle = UITableViewCellSelectionStyleNone;
    theView.backgroundColor = [UIColor clearColor];
    theView.showsVerticalScrollIndicator = false;
    theView.delegate = self;
    theView.dataSource = self;
    _theTableView = theView;
  }
  return _theTableView;
}
@end
