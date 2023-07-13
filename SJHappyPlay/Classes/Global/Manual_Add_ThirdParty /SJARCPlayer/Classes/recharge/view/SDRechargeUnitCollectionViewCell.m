//
//  SDRechargeUnitCollectionViewCell.m
//  wawajiGame
//
//  Created by sander shan on 2022/10/14.
//

#import "SDRechargeUnitCollectionViewCell.h"

#import "SDRechargeUnitDataModel.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface SDRechargeUnitCollectionViewCell ()

@property (nonatomic, weak) UIImageView * theLogoImageView;

@property (nonatomic, weak) UILabel * theRechargeLabel;

@property (nonatomic, weak) UILabel * theRechargeMoenyView;

@property (nonatomic, weak) UIView * theContentView;

@property (nonatomic, weak) UIView * theTagView;

@property (nonatomic, weak) UIImageView * theTagImageView;

@property (nonatomic, weak) UILabel * theTagLabel;

@property (nonatomic, weak) UILabel * theDescLabel;

@property (nonatomic, weak) UIView * theRechargeButton;
@end

@implementation SDRechargeUnitCollectionViewCell

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
    self.theContentView.layer.borderColor = [UIColor colorForHex:@"#FECA06"].CGColor;
    
    if (model.chargeType == SDRechargeItemCycle) {
        self.theContentView.layer.borderColor = [UIColor colorForHex:@"#542995"].CGColor;
    }
    
    self.theRechargeLabel.text = model.exchangeValue;
    
    self.theDescLabel.text = model.exchangeRemark;
    
    self.theTagLabel.text = model.mark;
    
    if ([model.mark isEqualToString:@"未知"]) {
        [self.theTagView setHidden:true];
    } else {
        [self.theTagView setHidden:false];
    }
    self.theRechargeMoenyView.text = [NSString stringWithFormat:@"¥%@",model.priceValue];
    if (model.chargeType == SDRechargeItemGold) {
        self.theLogoImageView.image = [PPImageUtil imageNamed:@"ico_gold"];
        self.theContentView.layer.borderColor = [UIColor colorForHex:@"#FECA06"].CGColor;
        self.theDescLabel.textColor = [UIColor colorForHex:@"#FECA06"];
        self.theRechargeButton.backgroundColor = [UIColor colorForHex:@"#FECA06"];
    } else if (model.chargeType == SDRechargeItemForDiamond) {
        self.theLogoImageView.image = [PPImageUtil imageNamed:@"ico_zs"];
        self.theContentView.layer.borderColor = [UIColor colorForHex:@"#53E053"].CGColor;
        self.theDescLabel.textColor = [UIColor colorForHex:@"#53E053"];
        self.theRechargeButton.backgroundColor = [UIColor colorForHex:@"#53E053"];
    }
    CGRect rechargeFrame = [self.theRechargeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.theRechargeLabel.font} context:nil];
    [self.theLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.theContentView).offset(-rechargeFrame.size.width / 2.0 - DSize(5));
    }];
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

- (UIImageView *)theLogoImageView{
    if (!_theLogoImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.theContentView addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(DSize(44));
            make.height.mas_equalTo(DSize(44));
            make.centerX.equalTo(self.theContentView);
            make.top.equalTo(self.theContentView).offset(DSize(30));
        }];
        _theLogoImageView = theView;
    }
    return _theLogoImageView;
}
- (UILabel *)theRechargeLabel{
    if (!_theRechargeLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.theLogoImageView.mas_right).offset(DSize(10));
            make.centerY.equalTo(self.theLogoImageView.mas_centerY);
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
            make.top.equalTo(self.theLogoImageView.mas_bottom).offset(DSize(20));
        }];
        theView.font = [UIFont systemFontOfSize:DFont(26)];
        theView.textColor = [UIColor colorForHex:@"#DDA300"];
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
        theView.backgroundColor = [UIColor colorForHex:@"#FECA06"];
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
@end
