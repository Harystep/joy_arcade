//
//  SDRechargeUnitCollectionViewCell.m
//  wawajiGame
//
//  Created by sander shan on 2022/10/14.
//

#import "SDRechargeUnitCycleCollectionViewCell.h"

#import "SDRechargeUnitDataModel.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

#import "PPChargeUnitModel.h"


@interface SDRechargeUnitCycleCollectionViewCell ()


@property (nonatomic, weak) UILabel * theRechargeLabel;

@property (nonatomic, weak) UILabel * theRechargeMoenyView;

@property (nonatomic, weak) UIView * theContentView;

@property (nonatomic, weak) UIView * theTagView;

@property (nonatomic, weak) UIImageView * theTagImageView;

@property (nonatomic, weak) UILabel * theTagLabel;

@property (nonatomic, weak) UILabel * theDescLabel;

@property (nonatomic, weak) UIView * theRechargeButton;


@property (nonatomic, weak) UIView * theRechargeDescContentView;

@property (nonatomic, weak) UILabel * theRechargeDescLabel;

@end

@implementation SDRechargeUnitCycleCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self theContentView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self theContentView];
    }
    return self;
}

- (void)loadDataModel:(SDRechargeUnitDataModel * )model {
    
    [self theTagView];
    [self theTagImageView];
    
    self.theContentView.backgroundColor = [UIColor whiteColor];
    self.theContentView.layer.masksToBounds = true;
    self.theContentView.layer.cornerRadius = DSize(20);
    self.theContentView.layer.borderWidth = DSize(2);
    self.theContentView.layer.borderColor = [UIColor colorForHex:@"#17BDFD"].CGColor;
    
    self.theRechargeLabel.text = model.exchangeValue;
    
    self.theDescLabel.text = model.exchangeRemark;
    
    self.theTagLabel.text = model.mark;
    
    if ([model.mark isEqualToString:@"未知"]) {
        [self.theTagView setHidden:true];
    } else {
        [self.theTagView setHidden:false];
    }
    self.theRechargeMoenyView.text = [NSString stringWithFormat:@"¥%@",model.priceValue];
    
    self.theRechargeDescLabel.text = [NSString stringWithFormat:@"立即到账%@", model.originData.money];
    CGRect rechargeFrame = [self.theRechargeDescLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.theRechargeDescLabel.font} context:nil];
    
    [self.theRechargeDescContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rechargeFrame.size.width + DSize(10));
    }];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rechargeFrame.size.width + DSize(10), DSize(34)) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(DSize(17), DSize(17))];
    maskLayer.path = [path CGPath];
    
    self.theRechargeDescContentView.layer.mask = maskLayer;
    
}

#pragma mark - lazy UI

- (UIView *)theContentView{
    if (!_theContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(DSize(10));
            make.top.equalTo(self.contentView).offset(DSize(10));
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        theView.backgroundColor = [UIColor redColor];
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
- (UILabel *)theRechargeLabel{
    if (!_theRechargeLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView);
            make.top.equalTo(self.theContentView).offset(DSize(30));
        }];
        theView.font = AutoBoldPxFont(40);
        theView.textColor = [UIColor colorForHex:@"#333333"];
        _theRechargeLabel = theView;
    }
    return _theRechargeLabel;
}
- (UILabel *)theDescLabel{
    if (!_theDescLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theContentView);
            make.top.equalTo(self.theRechargeLabel.mas_bottom).offset(DSize(20));
        }];
        theView.font = [UIFont systemFontOfSize:DFont(26)];
        theView.textColor = [UIColor colorForHex:@"#17BDFD"];
        _theDescLabel = theView;
    }
    return _theDescLabel;
}
- (UIView *)theRechargeButton{
    if (!_theRechargeButton) {
        UIView * theView = [[UIView alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theContentView);
            make.right.equalTo(self.theContentView);
            make.bottom.equalTo(self.theContentView);
            make.height.mas_equalTo(DSize(60));
        }];
        theView.backgroundColor = [UIColor colorForHex:@"#17BDFD"];
        _theRechargeButton = theView;
    }
    return _theRechargeButton;
}
- (UILabel *)theRechargeMoenyView{
    if (!_theRechargeMoenyView) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theRechargeButton addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.theRechargeButton);
        }];
        theView.font = AutoBoldPxFont(28);
        theView.textColor = [UIColor whiteColor];
        _theRechargeMoenyView = theView;
    }
    return _theRechargeMoenyView;
}
- (UIView *)theRechargeDescContentView{
    if (!_theRechargeDescContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theContentView);
            make.bottom.equalTo(self.theRechargeButton.mas_top).offset(DSize(-10));
            make.height.mas_equalTo(DSize(34));
            make.width.mas_equalTo(0);
        }];
        theView.backgroundColor = [UIColor colorForHex:@"#17BDFD"];
        _theRechargeDescContentView = theView;
    }
    return _theRechargeDescContentView;
}

- (UILabel *)theRechargeDescLabel{
    if (!_theRechargeDescLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theRechargeDescContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.theRechargeDescContentView);
        }];
        theView.font = [UIFont systemFontOfSize:DFont(22)];
        theView.textColor = [UIColor whiteColor];
        _theRechargeDescLabel = theView;
    }
    return _theRechargeDescLabel;
}

@end

