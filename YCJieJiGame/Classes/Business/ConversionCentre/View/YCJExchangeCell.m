//
//  YCJExchangeCell.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/30.
//

#import "YCJExchangeCell.h"
#import "YCJExchangeModel.h"

@interface YCJExchangeCell()
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) UIImageView   *coinImgView;
@property (nonatomic, strong) UILabel       *coinLB;
@property (nonatomic, strong) UILabel       *titleLB;

@end

@implementation YCJExchangeCell

/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier{
    static NSString *cellIdentifier = @"CollectionViewCellIdentifier";
    return cellIdentifier;
}

/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找方块视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的方块视图返回
    YCJExchangeCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:[YCJExchangeCell cellIdentifier]
                                                  forIndexPath:indexPath];
    return cell;
}

/* 注册了方块视图后，当缓存池中没有底部视图的对象时候，自动调用alloc/initWithFrame创建 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = kSize(8);
        [self configUI];
    }
    return self;
}


- (void)setExchangeModel:(YCJExchangeModel *)exchangeModel {
    self.coinLB.text = exchangeModel.goldCoin;
    self.titleLB.text = [NSString stringWithFormat:@"%@%@", exchangeModel.points, ZCLocalizedString(@"积分", nil)];
}

- (void)configUI {
    [self.contentView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.containView addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];
    
    [self.containView addSubview:self.coinImgView];
    [self.containView addSubview:self.coinLB];
    [self.containView addSubview:self.titleLB];
    [self.coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView).offset(-25);
        make.size.mas_equalTo(45);
        make.top.mas_equalTo(40);
    }];
    
    [self.coinLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinImgView.mas_right).offset(10);
        make.centerY.equalTo(self.coinImgView);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-5);
    }];
}

#pragma mark -- lazy
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor clearColor];
        _containView.layer.cornerRadius = 9;
        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [UIImageView new];
        _contentBgView.contentMode = UIViewContentModeScaleToFill;
        _contentBgView.image = [UIImage imageNamed:@"icon_exchange_cell_bg"];
    }
    return _contentBgView;
}


- (UIImageView *)coinImgView {
    if (!_coinImgView) {
        _coinImgView = [UIImageView new];
        _coinImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coinImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
    }
    return _coinImgView;
}

- (UILabel *)coinLB {
    if (!_coinLB) {
        _coinLB = [[UILabel alloc] init];
        _coinLB.text = @"";
        _coinLB.textAlignment = NSTextAlignmentCenter;
        _coinLB.font = kPingFangSemiboldFont(24);
        _coinLB.textColor = kCommonWhiteColor;
    }
    return _coinLB;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(16);
        _titleLB.textColor = kColorHex(0x173166);
    }
    return _titleLB;
}

@end
