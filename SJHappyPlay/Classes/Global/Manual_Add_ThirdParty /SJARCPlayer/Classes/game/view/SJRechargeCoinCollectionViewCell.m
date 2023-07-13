

#import "SJRechargeCoinCollectionViewCell.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"
#import "NSString+MD5.h"
#import "AppDefineHeader.h"

@interface SJRechargeCoinCollectionViewCell ()
@property (nonatomic, weak) UIView * theContentView;
@property (nonatomic, weak) UILabel * theCoinCountLabel;
@property (nonatomic, weak) UIView * theDesContentView;
@property (nonatomic, weak) UILabel * theDesLabel;
@property (nonatomic, weak) UIView * theBottomChargeView;
@property (nonatomic, weak) UILabel * theChargePriceLabel;
@property (nonatomic,strong) UILabel *theShopLabel;
@property (nonatomic, weak) UIView * theTagView;
@property (nonatomic,strong) UILabel *theTitleLabel;
@property (nonatomic, weak) UIImageView * theTagImageView;
@property (nonatomic,strong) UIImageView *theCoinIv;
@property (nonatomic, weak) UILabel * theTagLabel;
@property (nonatomic,strong) UIView *theNormalCountView;
@property (nonatomic,strong) UILabel *theNormalCountLabel;
@property (nonatomic,strong) UIImageView *bgIcon;

@end
@implementation SJRechargeCoinCollectionViewCell

- (void)loadCoinModel:(PPChargetCoinData * )data{
    self.chargetCointData = data;
    [self theContentView];
    [self bgIcon];
    self.theCoinCountLabel.text = [self.chargetCointData coinCount];
    self.theChargePriceLabel.text = [NSString stringWithFormat:@"$%.2f", [self.chargetCointData.chargePrice doubleValue]];
    self.theShopLabel.text = ZCLocal(@"购买");
    self.theTitleLabel.text = ZCLocal(@"立即到账");
    NSString *dayMoney = self.chargetCointData.dayMoney;
    NSString *bgIconStr = @"img_coin_recharge_nor_content_bg_a";
    UIColor *color = RGBACOLOR(23, 49, 102, 1);
    BOOL preferentialFlag = NO;
    if(self.chargetCointData.type == 100001) {
        bgIconStr = [NSString convertImageNameWithLanguage:@"img_coin_recharge_day_content_bg_a_en"];
        color = RGBACOLOR(102, 23, 23, 1);
    } else if (self.chargetCointData.type == 100002) {
        bgIconStr = [NSString convertImageNameWithLanguage:@"img_coin_recharge_week_content_bg_a_en"];
        color = RGBACOLOR(102, 45, 23, 1);
    } else if (self.chargetCointData.type == 100003) {
        bgIconStr = [NSString convertImageNameWithLanguage:@"img_coin_recharge_month_content_bg_a_en"];
        color = RGBACOLOR(102, 23, 23, 1);
    } else {
        preferentialFlag = YES;
    }
    self.theTagLabel.hidden = preferentialFlag;
    self.theTitleLabel.hidden = preferentialFlag;
    if(preferentialFlag) {
        self.theCoinCountLabel.hidden = YES;
        self.theCoinCountLabel.textColor = UIColor.whiteColor;
        [self theNormalCountView];
        [self theCoinIv];
        [self theNormalCountLabel].text = [self.chargetCointData coinCount];
        self.theCoinIv.hidden = NO;
        self.theNormalCountLabel.hidden = NO;
    } else {
        self.theCoinIv.hidden = YES;
        self.theNormalCountLabel.hidden = YES;
        self.theCoinCountLabel.hidden = NO;
        self.theCoinCountLabel.textColor = color;
        if([dayMoney integerValue] > 0) {
            self.theTagLabel.hidden = NO;
            self.theTagLabel.text = [NSString stringWithFormat:@"%@%@", ZCLocal(@"每日赠送"), self.chargetCointData.dayMoney];
        } else {
            self.theTagLabel.hidden = YES;
        }
    }
    [self.bgIcon setImage:[PPImageUtil imageNamed:bgIconStr]];
    self.theChargePriceLabel.textColor = color;
    self.theShopLabel.textColor = color;
    self.theTitleLabel.textColor = color;
    self.theTagLabel.textColor = color;
    self.theDesLabel.text = self.chargetCointData.des;
    
    self.theTitleLabel.hidden = YES;
}
#pragma mark - lazy
- (UIView * )theContentView{
    if (!_theContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        _theContentView = theView;
    }
    return _theContentView;
}

- (UIView *)theTagView{
    if (!_theTagView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.width.mas_equalTo(DSize(128));
            make.height.mas_equalTo(DSize(50));
        }];
        
        _theTagView = theView;
    }
    return _theTagView;
}

- (UIImageView *)theTagImageView{
    if (!_theTagImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.theTagView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(128));
            make.height.mas_equalTo(DSize(50));
        }];
        theView.image = [PPImageUtil imageNamed:@"ico_recharge_tag"];
        _theTagImageView = theView;
    }
    return _theTagImageView;
}

- (UILabel *)theTagLabel{
    if (!_theTagLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView);
            make.top.mas_equalTo(self.theCoinCountLabel.mas_bottom).offset(DSize(4));
        }];
        theView.font = [UIFont systemFontOfSize:DSize(22)];
        theView.textColor = [UIColor whiteColor];
        _theTagLabel = theView;
    }
    return _theTagLabel;
}

- (UILabel * )theCoinCountLabel{
    if (!_theCoinCountLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView.mas_centerX);
            make.top.mas_equalTo(self.theContentView.mas_top).offset(DSize(82));
        }];
        theView.font = AutoMediumPxFont(48);
        theView.textColor = UIColor.whiteColor;
        _theCoinCountLabel = theView;
    }
    return _theCoinCountLabel;
}

- (UILabel * )theDesLabel{
    if (!_theDesLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView);
            make.bottom.equalTo(self.theBottomChargeView.mas_top).inset(DSize(6));
            make.left.equalTo(self.theContentView).offset(DSize(20));
            make.right.equalTo(self.theContentView).offset(-DSize(20));
        }];
        theView.textColor = [UIColor whiteColor];
        theView.textAlignment = NSTextAlignmentCenter;
        theView.font = AutoPxFont(22);
        _theDesLabel = theView;
//        _theDesLabel.hidden = YES;
    }
    return _theDesLabel;
}
- (UIView * )theBottomChargeView{
    if (!_theBottomChargeView) {
        UIView * theView = [[UIView alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theContentView);
            make.right.equalTo(self.theContentView);
            make.height.mas_equalTo(SF_Float(70));
            make.bottom.equalTo(self.theContentView.mas_bottom);
        }];
        _theBottomChargeView = theView;
    }
    return _theBottomChargeView;
}
- (UILabel * )theChargePriceLabel{
    if (!_theChargePriceLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theBottomChargeView addSubview:theView];
        theView.font = AutoBoldPxFont(32);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.theBottomChargeView);
            make.leading.mas_equalTo(self.theBottomChargeView.mas_leading).offset(DSize(22));
        }];
        _theChargePriceLabel = theView;
    }
    return _theChargePriceLabel;
}

- (UILabel *)theShopLabel {
    if (!_theShopLabel) {
        UILabel *theView = [[UILabel alloc] init];
        [self.theBottomChargeView addSubview:theView];
        theView.font = AutoBoldPxFont(32);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.theBottomChargeView);
            make.trailing.mas_equalTo(self.theBottomChargeView.mas_trailing).inset(DSize(22));
        }];
        _theShopLabel = theView;
    }
    return _theShopLabel;
}

- (UILabel *)theTitleLabel {
    if (!_theTitleLabel) {
        UILabel *theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        theView.font = AutoBoldPxFont(32);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView);
            make.top.mas_equalTo(self.theContentView.mas_top).offset(DSize(50));
        }];
        _theTitleLabel = theView;
    }
    return _theTitleLabel;
}

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"img_point_exchange_content_bg_a"]];
        [self.theContentView addSubview:_bgIcon];
        [_bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.theContentView);
        }];
    }
    return _bgIcon;
}

- (UIView *)theNormalCountView {
    if (!_theNormalCountView) {
        _theNormalCountView = [[UIView alloc] init];
        [self.theContentView addSubview:_theNormalCountView];
        [_theNormalCountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.theContentView.mas_centerX);
            make.height.mas_equalTo(DSize(68));
            make.top.mas_equalTo(self.theContentView.mas_top).offset(DSize(68));
        }];
    }
    return _theNormalCountView;
}

- (UILabel *)theNormalCountLabel{
    if (!_theNormalCountLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theNormalCountView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.theCoinIv.mas_centerY);
            make.top.mas_equalTo(self.theContentView.mas_top).offset(DSize(82));
            make.trailing.mas_equalTo(self.theNormalCountView.mas_trailing);
            make.leading.mas_equalTo(self.theCoinIv.mas_trailing);
        }];
        theView.font = AutoMediumPxFont(48);
        theView.textColor = UIColor.whiteColor;
        _theNormalCountLabel = theView;
    }
    return _theNormalCountLabel;
}

- (UIImageView *)theCoinIv {
    if (!_theCoinIv) {
        _theCoinIv = [[UIImageView alloc] init];
        _theCoinIv.image = [PPImageUtil imageNamed:@"img_game_coin_a"];
        [self.theNormalCountView addSubview:_theCoinIv];
        [_theCoinIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.theNormalCountView.mas_leading);
            make.centerY.mas_equalTo(self.theNormalCountView);
            make.width.height.mas_equalTo(DSize(60));
        }];
    }
    return _theCoinIv;
}

@end
