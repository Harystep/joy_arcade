//
//  YCJShopZuansCell.m
//  YCJieJiGame
//
//  Created by John on 2023/5/31.
//

#import "YCJShopZuansCell.h"
#import "YCJShopModel.h"

@interface YCJShopZuansCell ()
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) UIImageView   *coinImgView;
@property (nonatomic, strong) UILabel       *coinLB;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UILabel       *subtitleLB;
@property (nonatomic, strong) UIImageView   *zsImgView;
@property (nonatomic, strong) UIButton      *buyBtn;

@end

@implementation YCJShopZuansCell

/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier{
    static NSString *cellIdentifier = @"zuansCollectionViewCellIdentifier";
    return cellIdentifier;
}

/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找方块视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的方块视图返回
    YCJShopZuansCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:[YCJShopZuansCell cellIdentifier]
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
        make.centerX.equalTo(self.containView).offset(-35);
        make.size.mas_equalTo(45);
        make.top.mas_equalTo(30);
    }];
    
    [self.coinLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinImgView.mas_right).offset(10);
        make.centerY.equalTo(self.coinImgView);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView).offset(15);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-5);
    }];
    
    [self.containView addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(90);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-5);
    }];
    
    [self.containView addSubview:self.subtitleLB];
    [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.buyBtn.mas_top).offset(-4);
    }];
    
//    [self.containView addSubview:self.zsImgView];
//    [self.zsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.subtitleLB);
//        make.size.mas_equalTo(12);
//        make.left.equalTo(self.subtitleLB.mas_right).offset(5);
//    }];
}

- (void)setGoodModel:(YCJShopCellModel *)goodModel {
    
    self.coinLB.text = goodModel.money;
    self.titleLB.text = [NSString stringWithFormat:@"￥%@", goodModel.price];
    self.subtitleLB.text = goodModel.desc;
}

- (void)bugAction {
    NSLog(@"购买");
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
        _contentBgView.image = [UIImage imageNamed:@"icon_shop_zs_bg"];
    }
    return _contentBgView;
}

- (UIImageView *)coinImgView {
    if (!_coinImgView) {
        _coinImgView = [UIImageView new];
        _coinImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coinImgView.image = [UIImage imageNamed:@"icon_shop_zs"];
    }
    return _coinImgView;
}

- (UILabel *)coinLB {
    if (!_coinLB) {
        _coinLB = [[UILabel alloc] init];
        _coinLB.text = @"5566";
        _coinLB.textAlignment = NSTextAlignmentCenter;
        _coinLB.font = kPingFangSemiboldFont(24);
        _coinLB.textColor = kCommonWhiteColor;
    }
    return _coinLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.text = @"次日再送 388";
        _subtitleLB.textAlignment = NSTextAlignmentCenter;
        _subtitleLB.font = kPingFangRegularFont(12);
        _subtitleLB.textColor = kColorHex(0xD0DDFF);
    }
    return _subtitleLB;
}

- (UIImageView *)zsImgView {
    if (!_zsImgView) {
        _zsImgView = [UIImageView new];
        _zsImgView.contentMode = UIViewContentModeScaleAspectFit;
        _zsImgView.image = [UIImage imageNamed:@"icon_shop_zs"];
    }
    return _zsImgView;
}


- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"￥188";
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.font = kPingFangSemiboldFont(16);
        _titleLB.textColor = kColorHex(0x173166);
    }
    return _titleLB;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:kColorHex(0x173166) forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = kPingFangSemiboldFont(16);
        _buyBtn.userInteractionEnabled = NO;
        [_buyBtn addTarget:self action:@selector(bugAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}
@end
