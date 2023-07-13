#import "PPChargetCoinCollectionViewCell.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPChargetCoinCollectionViewCell ()
@property (nonatomic, weak) UIView * theContentView;
@property (nonatomic, weak) UIImageView * theLogoImageView;
@property (nonatomic, weak) UILabel * theCoinCountLabel;
@property (nonatomic, weak) UIView * theDesContentView;
@property (nonatomic, weak) UILabel * theDesLabel;
@property (nonatomic, weak) UIView * theBottomChargeView;
@property (nonatomic, weak) UILabel * theChargePriceLabel;

@property (nonatomic, weak) UIView * theTagView;

@property (nonatomic, weak) UIImageView * theTagImageView;

@property (nonatomic, weak) UILabel * theTagLabel;

@property (nonatomic,strong) UIImageView *bgIcon;

@end
@implementation PPChargetCoinCollectionViewCell

- (void)loadCoinModel:(PPChargetCoinData * )data{
    self.chargetCointData = data;
    [self theContentView];
    [self bgIcon];
    [self theLogoImageView];
    self.theCoinCountLabel.text = [self.chargetCointData coinCount];
    
    self.theDesLabel.text = self.chargetCointData.des;
    
    if (self.chargetCointData.type == 10) {
        self.theChargePriceLabel.text = [NSString stringWithFormat:@"%@%@", self.chargetCointData.chargePrice, ZCLocal(@"积分兑换_alert")];
    } else {
        self.theDesLabel.textColor = [UIColor colorForHex:@"#FECA06"];
        self.theContentView.layer.borderColor = [UIColor colorForHex:@"#FECA06"].CGColor;
        self.theChargePriceLabel.text = [NSString stringWithFormat:@"¥%@", self.chargetCointData.chargePrice];
    }
    
    CGRect rechargeFrame = [self.theCoinCountLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.theCoinCountLabel.font} context:nil];
    [self.theLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.theContentView).offset(-rechargeFrame.size.width / 2.0 - DSize(5));
    }];
}
#pragma mark - lazy
- (UIView * )theContentView{
    if (!_theContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = SF_Float(20);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(DSize(10));
            make.top.equalTo(self.contentView).offset(DSize(10));
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        _theContentView = theView;
    }
    return _theContentView;
}

- (UIView *)theTagView {
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
        [self.theTagView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theTagView);
            make.centerY.equalTo(self.theTagView).offset(-DSize(8));
        }];
        theView.font = [UIFont systemFontOfSize:DSize(22)];
        theView.textColor = [UIColor whiteColor];
        _theTagLabel = theView;
    }
    return _theTagLabel;
}

- (UIImageView * )theLogoImageView{
    if (!_theLogoImageView) {
        UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"img_game_coin_a"]];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(SF_Float(64));
            make.height.mas_equalTo(SF_Float(64));
            make.top.equalTo(self.theContentView).offset(SF_Float(82));
            make.centerX.equalTo(self.theContentView);
        }];
        _theLogoImageView = theView;
    }
    return _theLogoImageView;
}
- (UILabel * )theCoinCountLabel{
    if (!_theCoinCountLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.theLogoImageView.mas_centerY);
            make.left.equalTo(self.theLogoImageView.mas_right).offset(SF_Float(7));
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
            make.top.equalTo(self.theLogoImageView.mas_bottom).offset(DSize(20));
            make.left.equalTo(self.theContentView).offset(DSize(20));
            make.right.equalTo(self.theContentView).offset(-DSize(20));
        }];
        theView.textColor = [UIColor blackColor];
        theView.numberOfLines = 0;
        theView.textAlignment = NSTextAlignmentCenter;
        theView.font = AutoPxFont(22);
        _theDesLabel = theView;
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
//        theView.backgroundColor = [UIColor colorForHex:@"#FECA06"];
        _theBottomChargeView = theView;
    }
    return _theBottomChargeView;
}
- (UILabel * )theChargePriceLabel{
    if (!_theChargePriceLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theBottomChargeView addSubview:theView];
        theView.font = AutoBoldPxFont(32);
        theView.textColor = RGBACOLOR(23, 49, 102, 1);
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.theBottomChargeView);
        }];
        _theChargePriceLabel = theView;
    }
    return _theChargePriceLabel;
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

@end
