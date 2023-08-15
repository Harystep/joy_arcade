//
//  YCJPlayLasterItemCell.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJPlayLasterItemCell.h"
#import "YCJPlayLasterSimpleCell.h"
#import "SDGameModule.h"
#import "PPGameConfig.h"
#import "PPNetworkConfig.h"
#import "PPGameConfig.h"
#import "PPUserInfoService.h"

@interface YCJPlayLasterItemCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation YCJPlayLasterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)playLasterItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    YCJPlayLasterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCJPlayLasterItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = rgba(92, 121, 183, 1);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    [bgView setViewCornerRadiu:8];
    CGFloat width = 15;
    if([SJLocalTool getCurrentLanguage] == 3) {
        width = 12;
    }
    UILabel *lb = [self createSimpleLabelWithTitle:ZCLocalizedString(@"最近访问", nil) font:12 bold:NO color:kCommonWhiteColor];
    [bgView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(12);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kSize(98));
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.top.mas_equalTo(bgView);
    }];
    lb.numberOfLines = 0;
    
    [bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(bgView);
        make.leading.mas_equalTo(bgView.mas_leading).offset(30);
    }];
    
    [self initPPGameSDK];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCJPlayLasterSimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCJPlayLasterSimpleCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    [JKNetWorkManager postRequestWithUrlPath:JKGameRoomEnterUrlKey parameters:@{@"roomId": dataDic[@"roomId"]} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        }else {
            /// 进入房间成功
            [MBProgressHUD showSuccess:ZCLocalizedString(@"进入房间成功", nil)];
            NSString *machineSn = dataDic[@"machineSn"];
            if (![[JKTools handelString:machineSn] isEqualToString:@""]){
                [SDGameModule presentViewController:machineSn roomId:dataDic[@"roomId"] machineType:[dataDic[@"machineType"] integerValue] inRootController:self.parentController];
            }      
        }
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建布局对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(kSize(98), kSize(81));
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;//设置代理
        _collectionView.dataSource = self;//设置数据源
        _collectionView.backgroundColor = [UIColor clearColor];//设置背景，默认为黑色
        [_collectionView registerClass:[YCJPlayLasterSimpleCell class] forCellWithReuseIdentifier:@"YCJPlayLasterSimpleCell"];
    }
    return _collectionView;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
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
}

@end
