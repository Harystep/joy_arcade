//
//  YCJRankCell.m
//  YCJieJiGame
//
//  Created by zza on 2023/5/24.
//

#import "YCJRankCell.h"

@interface YCJRankCell()

@property (nonatomic, strong) UIView        *containView;
/// 左边图标
@property (nonatomic, strong) UIImageView   *rankImgView;
@property (nonatomic, strong) UILabel       *rankLB;
/// 头像
@property (nonatomic, strong) UIImageView   *headImgView;
/// 中间文案
@property (nonatomic, strong) UILabel       *nameLabel;
/// 下边时间
@property (nonatomic, strong) UILabel       *jifenLabel;
/// 横线
@property (nonatomic, strong) UIView        *lineView;

@end

@implementation YCJRankCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJRankCell *cell = (YCJRankCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        cell.contentView.backgroundColor = kColorHex(0x5C79B7);
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

- (void)setRankModel:(YCJRankListModel *)rankModel {
    
    self.nameLabel.text = rankModel.nickName;
    self.jifenLabel.text = rankModel.total;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:rankModel.avatar]];
    if ([rankModel.rank intValue] <= 3) {
        self.rankImgView.hidden = false;
        self.rankLB.text = @"";
        self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_phb_%d", [rankModel.rank intValue]]];
    } else {
        self.rankLB.text = rankModel.rank;
        self.rankImgView.hidden = false;
        self.rankImgView.image = [UIImage new];
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.rankImgView];
    [self.rankImgView addSubview:self.rankLB];
    [self.containView addSubview:self.headImgView];
    [self.containView addSubview:self.nameLabel];
    [self.containView addSubview:self.jifenLabel];
    [self.containView addSubview:self.lineView];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(15));
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(38);
        make.centerY.equalTo(self.containView);
    }];
    [self.rankLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rankImgView);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankImgView.mas_right).offset(kSize(15));
        make.width.height.mas_equalTo(kSize(36));
        make.centerY.equalTo(self.containView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(kSize(15));
        make.centerY.equalTo(self.containView);
    }];
    
    [self.jifenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.containView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark -
#pragma mark -- lazy
- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc] init];
    }
    return _containView;
}
- (UIImageView *)rankImgView{
    if (!_rankImgView) {
        _rankImgView = [[UIImageView alloc] init];
        _rankImgView.cornerRadius = kSize(4);
    }
    return _rankImgView;
}

- (UILabel *)rankLB {
    if (!_rankLB) {
        _rankLB = [[UILabel alloc] init];
        _rankLB.text = @"";
        _rankLB.textAlignment = NSTextAlignmentCenter;
        _rankLB.font = kPingFangSemiboldFont(18);
        _rankLB.textColor = kCommonWhiteColor;
    }
    return _rankLB;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headImgView.image = [UIImage imageNamed:@""];
        _headImgView.cornerRadius = kSize(18);
        _headImgView.borderColor = kCommonWhiteColor;
        _headImgView.borderWidth = 2;
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kPingFangRegularFont(14);
        _nameLabel.textColor = kCommonWhiteColor;
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)jifenLabel{
    if (!_jifenLabel) {
        _jifenLabel = [[UILabel alloc] init];
        _jifenLabel.font = kPingFangSemiboldFont(16);
        _jifenLabel.textColor = kCommonWhiteColor;
        _jifenLabel.text = @"";
        _jifenLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _jifenLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [kCommonWhiteColor colorWithAlphaComponent:0.15];
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
