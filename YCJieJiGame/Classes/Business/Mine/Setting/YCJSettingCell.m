//
//  YCJSettingCell.m
//  YCJieJiGame
//
//  Created by zza on 2023/5/22.
//

#import "YCJSettingCell.h"
#import "YCJMineInfoModel.h"

@interface YCJSettingCell()

/// 左边图标
@property (nonatomic, strong) UIImageView *leftImageView;
/// 左边文案
@property (nonatomic, strong) UILabel *leftLabel;
/// 右箭头
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation YCJSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJSettingCell *cell = (YCJSettingCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
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
    [self.contentView addSubview:self.arrowImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
        make.width.height.mas_equalTo(kSize(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(kSize(8));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kMargin);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
    
}
#pragma mark - 赋值
#pragma mark --
- (void)setSettingInfoModel:(YCJMineInfoModel *)settingInfoModel {
    self.leftImageView.image = [UIImage imageNamed:settingInfoModel.leftIcon];
    self.leftLabel.text = settingInfoModel.leftStr;
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
        _leftLabel.font = kPingFangMediumFont(15);
        _leftLabel.textColor = kCommonBlackColor;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_mine_arrowR"];
    }
    
    return _arrowImageView;
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
