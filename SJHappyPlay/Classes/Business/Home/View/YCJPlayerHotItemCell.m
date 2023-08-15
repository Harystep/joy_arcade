//
//  YCJPlayerHotItemCell.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJPlayerHotItemCell.h"
#import "YCJGameRoomModel.h"

@interface YCJPlayerHotItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *subL;

@property (nonatomic,strong) UILabel *numL;

@property (nonatomic,strong) UIButton *jumpBtn;

@end

@implementation YCJPlayerHotItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)playerHotItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    YCJPlayerHotItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCJPlayerHotItemCell" forIndexPath:indexPath];
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
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSize(80));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(3);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(8);
    }];
    [self.iconIv setViewCornerRadiu:8];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
//    self.iconIv.backgroundColor = [UIColor whiteColor];
    
    self.nameL = [self createSimpleLabelWithTitle:@" " font:15 bold:YES color:kCommonWhiteColor];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.iconIv.mas_top);
    }];
    
    self.subL = [self createSimpleLabelWithTitle:@" " font:12 bold:NO color:kCommonWhiteColor];
    [self.contentView addSubview:self.subL];
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(3);
        make.height.mas_equalTo(17);
    }];
    
    self.numL = [self createSimpleLabelWithTitle:@" " font:12 bold:YES color:rgba(255, 255, 255, 0.6)];
    [self.contentView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
        make.top.mas_equalTo(self.subL.mas_bottom).offset(18);
        make.height.mas_equalTo(14);
    }];
    
    self.jumpBtn = [self createSimpleButtonWithTitle:ZCLocalizedString(@"进入", nil) font:14 color:kCommonWhiteColor];
    [self.contentView addSubview:self.jumpBtn];
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.width.mas_equalTo(kSize(62));
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(12);
    }];
    [self.jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpBtn layoutIfNeeded];
    [self.jumpBtn setViewBorderWithColor:2 color:rgba(226, 224, 255, 1)];
    [self addGradientLayerWithCorner:self.jumpBtn withCornerRadius:6 withLineWidth:4 withColors:@[(id)rgba(166, 181, 255, 1).CGColor,(id)rgba(82, 121, 206, 1).CGColor] start:CGPointMake(0.5, 0) end:CGPointMake(0.5, 1)];
    [self.jumpBtn setViewCornerRadiu:5];
    self.jumpBtn.userInteractionEnabled = NO;
    
}

- (void)jumpBtnClick {
    
}

- (void)addGradientLayerWithCorner:(UIView *)view withCornerRadius:(float)cornerRadius withLineWidth:(float)lineWidth withColors:(NSArray *)colors start:(CGPoint)point1 end:(CGPoint)point2 {
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    gradientLayer.colors = colors;
    gradientLayer.startPoint = point1;
    gradientLayer.endPoint = point2;
    gradientLayer.cornerRadius = cornerRadius;
        
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setRoomModel:(YCJGameRoomGroup *)roomModel {
    _roomModel = roomModel;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:roomModel.thumb] placeholderImage:nil];
    self.nameL.text = roomModel.name;
    self.subL.text = ZCLocalizedString(@"在线高清畅玩", nil);
    self.numL.text = roomModel.groupName;
    
}

@end
