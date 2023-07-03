

#import "YCJJinBiCell.h"
#import "YCJConsumeModel.h"

@interface YCJJinBiCell()
@property (nonatomic, strong) UIView *containView;
/// 左边文案
@property (nonatomic, strong) UILabel *topLabel;
/// 中间文案
@property (nonatomic, strong) UILabel *centerLabel;
/// 下边时间
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation YCJJinBiCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJJinBiCell *cell = (YCJJinBiCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
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

- (void)setConsumeModel:(YCJConsumeModel *)consumeModel {
    self.topLabel.text = consumeModel.remark;
    self.bottomLabel.text = consumeModel.createTime;
    self.centerLabel.text = consumeModel.money;
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.topLabel];
    [self.containView addSubview:self.centerLabel];
    [self.containView addSubview:self.bottomLabel];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(kSize(78));
        make.top.mas_equalTo(kSize(15));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView).offset(kSize(20));
        make.top.mas_equalTo(kSize(10));
        make.height.mas_equalTo(kSize(30));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topLabel);
        make.right.equalTo(self.containView).offset(-20);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom);
        make.left.equalTo(self.topLabel);
        make.height.mas_equalTo(kSize(25));
    }];
}

#pragma mark -
#pragma mark -- lazy
- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.cornerRadius = kSize(6);
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = kPingFangMediumFont(14);
        _topLabel.textColor = kCommonBlackColor;
        _topLabel.text = @"";
        _topLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _topLabel;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = kPingFangSemiboldFont(14);
        _centerLabel.textColor = kColorHex(0xDD7116);
        _centerLabel.text = @"";
        _centerLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _centerLabel;
}

- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = kPingFangRegularFont(12);
        _bottomLabel.textColor = kShallowBlackColor;
        _bottomLabel.text = @"";
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bottomLabel;
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
