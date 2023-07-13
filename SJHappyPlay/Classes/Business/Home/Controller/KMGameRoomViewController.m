

#import "KMGameRoomViewController.h"
#import "KMRoomListModel.h"
#import "KMGameRoomCell.h"
#import "KMRoomListModel.h"


#import "PPGameConfig.h"
#import "PPNetworkConfig.h"
#import "PPGameConfig.h"
#import "PPUserInfoService.h"

#import "SDGameModule.h"


@interface KMGameRoomViewController ()<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView     *collectionView;/* 容器视图 */
@property (nonatomic, strong) NSMutableArray        *roomList;

@end

@implementation KMGameRoomViewController

- (NSMutableArray *)roomList {
    if(!_roomList) {
        _roomList = [NSMutableArray array];
    }
    return _roomList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [JKTools handelString:self.titleStr];
    [self bgImageName:@"icon_home_bg"];
    [self initPPGameSDK];
    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SKUserInfoManager sharedInstance] reloadUserInfo];
}

#pragma mark -
#pragma mark -- initPPGameSDK
- (void)initPPGameSDK{
    [[PPGameConfig sharedInstance] configGame];
    /// 需要更换请求地址
    [PPNetworkConfig sharedInstance].base_request_url = kPPGameBaseRequestUrl;
    /// 更换 tcp请求的地址
    [PPNetworkConfig sharedInstance].base_my_host = kPPGameBaseMyHost;
    /// 更换 tcp 请求的 port
    [PPNetworkConfig sharedInstance].base_my_port = kPPGameBaseMyPort.integerValue;
    //添加渠道参数
    [PPNetworkConfig sharedInstance].channelKey = kPPGameChannelKey;
    
    
    YCJToken *userToken = [SKUserInfoManager sharedInstance].userTokenModel;
    if(userToken.accessToken.length > 0) {
        [[PPUserInfoService get_Instance] setAccess_token:userToken.accessToken];
    }
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenError) name:@"login_status_error" object:nil];
    
}
#pragma mark - token失效
#pragma mark -- tokenError
- (void)tokenError{
    
    
    
}

- (void)setRoomGroup:(YCJGameRoomGroup *)roomGroup {
    _roomGroup = roomGroup;
    [self requestRoomList];
}

- (void)requestRoomList {
    [JKNetWorkManager getRequestWithUrlPath:JKGameRoomListUrlKey parameters:@{@"categoryId": self.roomGroup.categoryId, @"groupId": self.roomGroup.roomGroupId} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.roomList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        }else {
            self.roomList = [KMRoomListModel mj_objectArrayWithKeyValuesArray:result.resultData[@"data"]];
            [self.collectionView reloadData];
        }
    }];
}

- (void)configUI {

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight);
    }];
}


#pragma mark - UICollectionViewDataSource
/* 设置容器中有多少个组 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/* 设置每个组有多少个方块 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.roomList.count;
}
/* 设置方块的视图 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
    KMGameRoomCell *cell =
            [KMGameRoomCell cellWithCollectionView:collectionView
                                            forIndexPath:indexPath];
    cell.roomModel = self.roomList[indexPath.item];
    return cell;
}


#pragma mark - UICollectionViewDelegate
/* 方块被选中会调用 */
- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击选择了第%ld组第%ld个方块",indexPath.section,indexPath.row);
    
    /// 进入房间
    KMRoomListModel *roomModel = self.roomList[indexPath.item];
    [JKNetWorkManager postRequestWithUrlPath:JKGameRoomEnterUrlKey parameters:@{@"roomId": roomModel.roomId} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            if(self.roomList.count > 0) {
                [MBProgressHUD showError:result.error.localizedDescription];
            }
        }else {
            /// 进入房间成功
            [MBProgressHUD showSuccess:ZCLocalizedString(@"进入房间成功", nil)];
            
            if (![[JKTools handelString:roomModel.machineSn] isEqualToString:@""]){
                [SDGameModule presentViewController:roomModel.machineSn roomId:roomModel.roomId machineType:roomModel.machineType.integerValue inRootController:self];
            }
            // 测试数据
//            [SDGameModule presentViewController:@"8cfca02127b4" machineType:1 inRootController:self];
            
        }
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
/* 设置各个方块的大小尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenWidth - 10 - 2 * kMargin) / 2;
    CGFloat height = 180;
    return CGSizeMake(width, height);
}
/* 设置每一组的上下左右间距 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kMargin, 0, kMargin);
}

#pragma mark -- lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建布局对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        _collectionView.delegate = self;//设置代理
        _collectionView.dataSource = self;//设置数据源
        _collectionView.backgroundColor = [UIColor clearColor];//设置背景，默认为黑色
        //注册容器视图中显示的方块视图
        [_collectionView registerClass:[KMGameRoomCell class]
                forCellWithReuseIdentifier:[KMGameRoomCell cellIdentifier]];
        //注册容器视图中显示的顶部视图
//        [_collectionView registerClass:[LTCollectionHeaderView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                  withReuseIdentifier:[LTCollectionHeaderView headerViewIdentifier]];
        //注册容器视图中显示的底部视图
//        [_collectionView registerClass:[LTCollectionFooterView class]
//           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                  withReuseIdentifier:[LTCollectionFooterView footerViewIdentifier]];
    }
    return _collectionView;
}
@end
