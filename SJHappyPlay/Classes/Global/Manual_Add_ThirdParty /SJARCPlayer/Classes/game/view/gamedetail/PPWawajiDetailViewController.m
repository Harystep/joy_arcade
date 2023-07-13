#import "PPWawajiDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PPDetailImageTableViewCell.h"
#import "PPDetailImageDataModel.h"
#import "AppDefineHeader.h"
@interface PPWawajiDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView* theTableView;
@property (nonatomic, strong) NSArray * imageList;
@end
@implementation PPWawajiDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  [self configView];
  self.imageList = @[];
  [self theTableView];
}
#pragma mark - configView
- (void)configView {
  self.view.backgroundColor = [UIColor whiteColor];
}
- (void)configData {
  @weakify(self);
  NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
  for (NSInteger i = 0; i < self.imgs.count; i ++ ) {
    NSString * image = self.imgs[i];
    PPDetailImageDataModel * imageDataModel = [[PPDetailImageDataModel alloc] initWithImg:image];
    [list addObject: imageDataModel];
    imageDataModel.row = i;
    [imageDataModel.updateSubject subscribeNext:^(id  _Nullable x) {
      NSInteger row = [x integerValue];
      @strongify(self);
      [self.theTableView reloadData];
    }];
  }
  self.imageList = [list copy];
  [[self theTableView] reloadData];
}
#pragma mark - public method
- (void)showView {
  onceToken = 0;
}
#pragma mark - set
- (void)setImgs:(NSArray *)imgs {
  _imgs = imgs;
  [self configData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.imageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPDetailImageDataModel * model = self.imageList[indexPath.row];
  PPDetailImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[model CellIdentifier]];
  [cell loadHomeDataModel:model];
  return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  PPDetailImageDataModel * model = self.imageList[indexPath.row];
  return model.hegiht_size_cell;
}
static dispatch_once_t onceToken;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat offsety = -scrollView.contentOffset.y;
  DLog(@"[scrollView] offset Y => %f",offsety);
  if (offsety > (SCREEH_HEIGHT / 4)) {
    dispatch_once(&onceToken, ^{
      [self.theActionSubject sendNext:@(1)];
    });
  }
}
#pragma mark - lazy UI
- (UITableView * )theTableView{
  if (!_theTableView) {
    UITableView * theView = [[UITableView alloc] init];
    [self.view addSubview:theView];
    theView.frame = self.view.bounds;
    theView.dataSource = self;
    theView.delegate = self;
    [theView registerClass:[PPDetailImageTableViewCell class] forCellReuseIdentifier:[PPDetailImageTableViewCell getCellIdentifier]];
    theView.separatorStyle = UITableViewCellSeparatorStyleNone;
    theView.tableFooterView = [UIView new];
    _theTableView = theView;
  }
  return _theTableView;
}
@end
