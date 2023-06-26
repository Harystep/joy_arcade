//
//  YCJMineListCell.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/19.
//

#import "YCJMineListCell.h"
#import "YCJMineInfoModel.h"
@interface YCJMineListCell ()

/// 左边图标
@property (nonatomic, strong) UIImageView *leftImageView;
/// 左边文案
@property (nonatomic, strong) UILabel *leftLabel;
/// 右边文案
@property (nonatomic, strong) UILabel *rightLabel;
/// 右箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 右边图标
@property (nonatomic, strong) UIImageView *rightImageView;
/// 横线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation YCJMineListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJMineListCell *cell = (YCJMineListCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        cell.contentView.backgroundColor = kColorHex(0xD8E2FF);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化控件
        [self configUI];
    }
    return self;
}


#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
        make.width.height.mas_equalTo(kSize(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(kSize(12));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kMargin);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-kSize(6));
        make.centerY.equalTo(self.contentView);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-kSize(6));
        make.width.height.mas_equalTo(kSize(40));
        make.centerY.equalTo(self.contentView);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
        make.right.equalTo(self.contentView).offset(-kMargin);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kLine_Height);
    }];
    
}
#pragma mark - 赋值
#pragma mark --
- (void)setMineInfoModel:(YCJMineInfoModel *)mineInfoModel{
    self.leftImageView.image = [UIImage imageNamed:mineInfoModel.leftIcon];
    self.leftLabel.text = mineInfoModel.leftStr;
    self.rightLabel.text = mineInfoModel.rightStr;
    if ([[YCJUserInfoManager sharedInstance].userInfoModel.authStatus intValue] == 1 && [mineInfoModel.rightStr isEqualToString:@"未认证"]) {
        self.rightLabel.text = @"已认证";
    }
    self.arrowImageView.hidden = mineInfoModel.isHiddenArrows;
}
///更新我的资料列表视图
- (void)updateMineInfoListView:(YCJMineInfoModel *)model{

    self.leftImageView.hidden = YES;
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
    }];
    
    if (model.detailInfoType == YCJCellDetailInfoTypeImg) {
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.rightStr] placeholderImage:[UIImage imageNamed:@"common_default_headImage"]];
        self.rightImageView.hidden = NO;
        self.rightLabel.hidden = YES;
    }else {
        self.rightImageView.hidden = YES;
        self.rightLabel.hidden = NO;
        self.rightLabel.text = model.rightStr;
    }
    
    self.leftLabel.text = model.leftStr;
    self.rightLabel.text = model.rightStr;
    self.arrowImageView.hidden = model.isHiddenArrows;

    self.leftLabel.font = kPingFangRegularFont(15);
    if (model.isHiddenArrows) {
        self.arrowImageView.hidden = YES;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kMargin);
        }];
    }else{
        self.arrowImageView.hidden = NO;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kSize(6));
        }];
    }
}

///更新版本信息列表视图
- (void)updateVersionInfoListView:(YCJMineInfoModel *)model{
    self.leftImageView.hidden = YES;
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
    }];
    if (model.detailInfoType == YCJCellDetailInfoTypeImg) {
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.rightStr] placeholderImage:[UIImage imageNamed:@"common_default_headImage"]];
        self.rightImageView.hidden = NO;
        self.rightLabel.hidden = YES;
    }else {
        self.rightImageView.hidden = YES;
        self.rightLabel.hidden = NO;
        self.rightLabel.text = model.rightStr;
    }
    self.leftLabel.text = model.leftStr;
    self.rightLabel.text = model.rightStr;
    self.arrowImageView.hidden = model.isHiddenArrows;
    self.leftLabel.font = kPingFangRegularFont(15);
    self.rightLabel.textColor = kShallowBlackColor;
    
    if (model.isHiddenArrows) {
        self.arrowImageView.hidden = YES;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-kMargin);
        }];
    }else{
        self.arrowImageView.hidden = NO;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kSize(6));
        }];
    }
}
#pragma mark -
#pragma mark -- lazy
- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = kPingFangMediumFont(16);
        _leftLabel.textColor = kColorHex(0x173166);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = kPingFangRegularFont(14);
        _rightLabel.textColor = kColorHex(0x8D98BE);
        _rightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_mine_arrowR"];
    }
    
    return _arrowImageView;
}
- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.clipsToBounds = YES;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.layer.masksToBounds = YES;
        _rightImageView.layer.cornerRadius = kSize(20);
    }
    return _rightImageView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineColor;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
