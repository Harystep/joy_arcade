//
//  YCJGameDetailCell.m
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJGameDetailCell.h"
#import "YCJComplaintReasonAlertView.h"

@interface YCJGameDetailCell()
@property (nonatomic, strong) UIView *containView;
/// 左边图标
@property (nonatomic, strong) UIImageView *leftImageView;
/// 中间文案
@property (nonatomic, strong) UILabel *centerLabel;
/// 下边时间
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIButton *shensuBtn;

@end

@implementation YCJGameDetailCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJGameDetailCell *cell = (YCJGameDetailCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
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

- (void)setDetailModel:(YCJGameDetailModel *)detailModel {
    _detailModel = detailModel;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.localUrl]];
    self.centerLabel.text = [NSString stringWithFormat:@"结算结果：%@积分", detailModel.points];
    self.bottomLabel.text = [NSString stringWithFormat:@"结束时间：%@", detailModel.updateTime];
}

- (void)complaintAction {
    /// 机器类型 1：娃娃机 3,5都属于推币机 4,6都属于街机类型
    if ([@[@"1", @"3", @"5"] containsObject:self.gameModel.type]) {
        /// 在控制器里面的结算按钮处理操作
    } else if ([@[@"4", @"6"] containsObject:self.gameModel.type]) {
        YCJComplaintReasonAlertView *view = [[YCJComplaintReasonAlertView alloc] init];
        view.gameModel = self.gameModel;
        view.detailModel = self.detailModel;
        [view show];
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.leftImageView];
    [self.containView addSubview:self.centerLabel];
    [self.containView addSubview:self.bottomLabel];
    [self.containView addSubview:self.shensuBtn];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(kSize(105));
        make.top.mas_equalTo(kSize(10));
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(15));
        make.top.mas_equalTo(kSize(15));
        make.width.height.mas_equalTo(kSize(76));
        make.bottom.mas_equalTo(-kSize(15));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.mas_right).offset(kSize(8));
        make.height.mas_equalTo(kSize(20));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerLabel.mas_bottom).offset(kSize(5));
        make.left.equalTo(self.centerLabel);
        make.height.mas_equalTo(kSize(20));
    }];
    
    [self.shensuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kMargin);
        make.width.mas_equalTo(kSize(75));
        make.height.mas_equalTo(kSize(30));
        make.bottom.mas_equalTo(-kSize(12));
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

- (UIButton *)shensuBtn {
    if (!_shensuBtn) {
        _shensuBtn = [[UIButton alloc] init];
        [_shensuBtn setTitle:@"结算申诉" forState:UIControlStateNormal];
        [_shensuBtn setBackgroundColor:kColorHex(0x6984EA)];
        _shensuBtn.cornerRadius = kSize(15);
        _shensuBtn.titleLabel.font = kPingFangRegularFont(14);
        [_shensuBtn addTarget:self action:@selector(complaintAction) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _shensuBtn;
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
