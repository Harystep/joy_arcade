#import "PPRecentlyCateLogViewController.h"
#import "ReactiveObjC.h"
#import "SJPCDollLogRoomRequestBaseModel.h"
#import "PPUserInfoService.h"
#import "PPGrabLogResponseModel.h"
#import "PPGrabLogDataModel.h"
#import "PPGrabLogTableViewCell.h"
#import "AppDefineHeader.h"
@interface PPRecentlyCateLogViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) RACCommand * netWorkCommand;
@property (nonatomic, weak) UITableView * theTableView;
@property (nonatomic, strong) NSArray <PPGrabLogDataModel *> * theGrabLogList;
@end
@implementation PPRecentlyCateLogViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  self.theGrabLogList = @[];
  [self configView];
  [self configData];
}
#pragma mark - configView
- (void)configView {
  self.view.backgroundColor = [UIColor redColor];
}
- (void)configData {
  @weakify(self);
  [[[self.netWorkCommand executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
    @strongify(self);
    SDGrabLogListModel * listModel = x;
    NSArray * list = listModel.data;
    self.theGrabLogList = list;
    [self.theTableView reloadData];
  }];
}
#pragma mark - public method
- (void)showView {
  onceToken = 0;
}
#pragma mark - set
- (void)setMachineSn:(NSString *)machineSn {
  _machineSn = machineSn;
  [self.netWorkCommand execute:self.machineSn];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.theGrabLogList.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPGrabLogDataModel * model = self.theGrabLogList[indexPath.row];
  PPGrabLogTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[model CellIdentifier]];
  [cell loadHomeDataModel:model];
  return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPGrabLogDataModel * model = self.theGrabLogList[indexPath.row];
  return model.hegiht_size_cell;
}
static dispatch_once_t onceToken;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat offsety = -scrollView.contentOffset.y;
  DLog(@"[cate log scrollView] offset Y => %f",offsety);
  if (offsety > (SCREEH_HEIGHT / 4)) {
    dispatch_once(&onceToken, ^{
      [self.theActionSubject sendNext:@(1)];
    });
  }
}
#pragma mark - lazy
- (RACCommand *)netWorkCommand
{
  if (!_netWorkCommand) {
    _netWorkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SJPCDollLogRoomRequestBaseModel * model = [[SJPCDollLogRoomRequestBaseModel alloc] init];
        model.accessToken = [PPUserInfoService get_Instance].access_token;
        model.machineId = input;
        [model requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
          if (error) {
            [subscriber sendError:nil];
          }else{
            [subscriber sendNext:responseModel];
            [subscriber sendCompleted];
          }
        }];
        return nil;
      }];
    }];
  }
  return _netWorkCommand;
}
- (UITableView * )theTableView{
  if (!_theTableView) {
    UITableView * theView = [[UITableView alloc] init];
    [self.view addSubview:theView];
    theView.frame = self.view.bounds;
    theView.delegate = self;
    theView.dataSource = self;
    [theView registerClass:[PPGrabLogTableViewCell class] forCellReuseIdentifier:[PPGrabLogTableViewCell getCellIdentifier]];
    theView.tableFooterView = [UIView new];
    _theTableView = theView;
  }
  return _theTableView;
}
@end
