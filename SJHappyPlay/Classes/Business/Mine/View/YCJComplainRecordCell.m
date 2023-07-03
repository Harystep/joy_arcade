

#import "YCJComplainRecordCell.h"
#import "YCJComplaintModel.h"

@interface YCJComplainRecordCell()
@property (nonatomic, strong) UIView *containView;
/// 左边图标
@property (nonatomic, strong) UIImageView *leftImageView;
/// 左边文案
@property (nonatomic, strong) UILabel *topLabel;
/// 中间文案
@property (nonatomic, strong) UILabel *centerLabel;
/// 下边时间
@property (nonatomic, strong) UILabel *bottomLabel;
/// 右下角按钮
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation YCJComplainRecordCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJComplainRecordCell *cell = (YCJComplainRecordCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
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

- (void)setComModel:(YCJComplaintModel *)comModel {
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:comModel.roomImg]];
    self.topLabel.text = comModel.roomName;
    if (comModel.points) {
        self.centerLabel.text = [NSString stringWithFormat:@"结算结果：%@积分", comModel.points];
    } else {
        self.centerLabel.text = @"";
    }
    self.bottomBtn.hidden = NO;
    NSString *btnTitle = @"";
    if (comModel.appealStatus == 0) {
        /// 申诉中，不可点击
        btnTitle = @"申诉中";
        self.bottomBtn.backgroundColor = kColorHex(0xE8B63D);
    } else if (comModel.appealStatus == 1) {
        /// 申诉成功
        btnTitle = @"申诉成功";
        self.bottomBtn.backgroundColor = kColorHex(0x21A22E);
    } else if (comModel.appealStatus == 2) {
        /// 申诉失败
        btnTitle = @"申诉失败";
        self.bottomBtn.backgroundColor = kColorHex(0x9C9C9C);
    } else {
        self.bottomBtn.hidden = YES;
    }
    [self.bottomBtn setTitle:btnTitle forState:UIControlStateNormal];
    self.bottomLabel.text = comModel.createTime;
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.leftImageView];
    [self.containView addSubview:self.topLabel];
    [self.containView addSubview:self.centerLabel];
    [self.containView addSubview:self.bottomLabel];
    [self.containView addSubview:self.bottomBtn];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(kSize(105));
        make.top.mas_equalTo(kSize(15));
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(15));
        make.width.height.mas_equalTo(kSize(76));
        make.centerY.equalTo(self.containView);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(kSize(8));
        make.top.equalTo(self.leftImageView);
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).offset(kSize(5));
        make.left.equalTo(self.topLabel);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftImageView.mas_bottom);
        make.left.equalTo(self.topLabel);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftImageView.mas_bottom);
        make.right.mas_equalTo(-kMargin);
        make.width.mas_equalTo(kSize(80));
        make.height.mas_equalTo(kSize(30));
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
- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.cornerRadius = kSize(4);
    }
    return _leftImageView;
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
        _centerLabel.font = kPingFangRegularFont(14);
        _centerLabel.textColor = kCommonBlackColor;
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

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.cornerRadius = kSize(15);
        _bottomBtn.titleLabel.font = kPingFangRegularFont(14);
        _bottomBtn.backgroundColor = kColorHex(0xE8B63D);
        [_bottomBtn setTitle:@"" forState:UIControlStateNormal];
    }
    return _bottomBtn;
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
