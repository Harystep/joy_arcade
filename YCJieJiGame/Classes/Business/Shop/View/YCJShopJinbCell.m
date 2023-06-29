//
//  YCJShopJinbCell.m
//  YCJieJiGame
//
//  Created by John on 2023/5/31.
//

#import "YCJShopJinbCell.h"
#import "YCJShopModel.h"

@interface YCJShopJinbCell()
@property (nonatomic, strong) UIView        *containView;
@property (nonatomic, strong) UIImageView   *contentBgView;
@property (nonatomic, strong) UIImageView   *coinImgView;
@property (nonatomic, strong) UILabel       *coinLB;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UILabel       *ljdzLB;
@property (nonatomic, strong) UILabel       *mrzsLB;
@property (nonatomic, strong) UILabel       *subtitleLB;
@property (nonatomic, strong) UIImageView   *zsImgView;
@property (nonatomic, strong) UIButton      *buyBtn;

@end

@implementation YCJShopJinbCell


/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier{
    static NSString *cellIdentifier = @"jinbiCollectionViewCellIdentifier";
    return cellIdentifier;
}

/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找方块视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的方块视图返回
    YCJShopJinbCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:[YCJShopJinbCell cellIdentifier]
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
    [self.containView addSubview:self.ljdzLB];
    [self.containView addSubview:self.coinLB];
    [self.containView addSubview:self.mrzsLB];
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
    
    [self.ljdzLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coinLB);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.coinLB.mas_top);
    }];
    
    [self.mrzsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coinLB);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.coinLB.mas_bottom);
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
        make.width.mas_equalTo(70);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-5);
    }];
    
    [self.containView addSubview:self.subtitleLB];
    [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.buyBtn.mas_top).offset(-8);
    }];
    
    [self.containView addSubview:self.zsImgView];
    [self.zsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subtitleLB);
        make.size.mas_equalTo(12);
        make.left.equalTo(self.subtitleLB.mas_right).offset(5);
    }];
}


- (void)setGoodModel:(YCJShopCellModel *)goodModel {
    
    if ([goodModel.mark containsString:@"月卡"]) {
        self.contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_shop_yk"]];
        self.ljdzLB.textColor = kColorHex(0x4B0A0A);
        self.mrzsLB.textColor = kColorHex(0x661717);
    } else if ([goodModel.mark containsString:@"周卡"]) {
        self.contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_shop_zk"]];
        self.ljdzLB.textColor = kColorHex(0x662D17);
        self.mrzsLB.textColor = kColorHex(0x662D17);
    } else if ([goodModel.mark containsString:@"首充"]) {
        self.contentBgView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_shop_mrsc"]];
        self.ljdzLB.textColor = kColorHex(0x4B0A0A);
        self.mrzsLB.textColor = kColorHex(0x661717);
    } else {
        self.contentBgView.image = [UIImage imageNamed:@"icon_shop_qt_bg"];
    }
    
    if ([@[@"月卡", @"周卡", @"首充"] containsObject:goodModel.mark]) {
        self.subtitleLB.textColor = kColorHex(0xFFF2DC);
        self.coinImgView.hidden = YES;
        self.ljdzLB.hidden = NO;
        self.mrzsLB.hidden = NO;
        [self.coinLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containView);
            make.centerY.equalTo(self.coinImgView);
        }];
        if([NSString isNullString:goodModel.dayMoney]) {
            self.mrzsLB.hidden = YES;
        } else {
            self.mrzsLB.text = [NSString stringWithFormat:@"%@%@", ZCLocalizedString(@"每日赠送", nil), goodModel.dayMoney];
        }
    } else {
        self.subtitleLB.textColor = kColorHex(0xD0DDFF);
        self.coinImgView.hidden = NO;
        self.ljdzLB.hidden = YES;
        self.mrzsLB.hidden = YES;
        
        [self.coinLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coinImgView.mas_right).offset(10);
            make.centerY.equalTo(self.coinImgView);
        }];
    }
    
    self.coinLB.text = goodModel.money;
    self.titleLB.text = [NSString stringWithFormat:@"$%.2f", [goodModel.price doubleValue]];
    self.subtitleLB.text = goodModel.desc;
    
    self.ljdzLB.hidden = YES;
}

- (void)bugAction {}

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
        _contentBgView.image = [UIImage imageNamed:@"icon_shop_qt_bg"];
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

- (UILabel *)ljdzLB {
    if (!_ljdzLB) {
        _ljdzLB = [[UILabel alloc] init];
        _ljdzLB.text = ZCLocalizedString(@"立即到账", nil);
        _ljdzLB.textAlignment = NSTextAlignmentLeft;
        _ljdzLB.font = kPingFangMediumFont(12);
        _ljdzLB.textColor = kColorHex(0x4B0A0A);
        _ljdzLB.hidden = YES;
    }
    return _ljdzLB;
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

- (UILabel *)mrzsLB {
    if (!_mrzsLB) {
        _mrzsLB = [[UILabel alloc] init];
        _mrzsLB.text = @"每日赠送388";
        _mrzsLB.textAlignment = NSTextAlignmentLeft;
        _mrzsLB.font = kPingFangRegularFont(12);
        _mrzsLB.textColor = kColorHex(0x661717);
    }
    return _mrzsLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.text = @"";
        _subtitleLB.textAlignment = NSTextAlignmentCenter;
        _subtitleLB.font = kPingFangRegularFont(12);
        _subtitleLB.textColor = kColorHex(0xD0DDFF);
//        _subtitleLB.hidden = YES;
    }
    return _subtitleLB;
}

- (UIImageView *)zsImgView {
    if (!_zsImgView) {
        _zsImgView = [UIImageView new];
        _zsImgView.contentMode = UIViewContentModeScaleAspectFit;
        _zsImgView.image = [UIImage imageNamed:@"icon_exchange_jb"];
        _zsImgView.hidden = YES;
    }
    return _zsImgView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"";
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.font = kPingFangSemiboldFont(16);
        _titleLB.textColor = kColorHex(0x173166);
    }
    return _titleLB;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setTitle:ZCLocalizedString(@"购买", nil) forState:UIControlStateNormal];
        [_buyBtn setTitleColor:kColorHex(0x173166) forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = kPingFangSemiboldFont(16);
        _buyBtn.userInteractionEnabled = NO;
        [_buyBtn addTarget:self action:@selector(bugAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

@end
