//
//  YCJComplaintDetailCell.m
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJComplaintDetailCell.h"

@interface YCJComplaintDetailCell()
@property (nonatomic, strong) UIView *containView;
/// 左边文案
@property (nonatomic, strong) UILabel *topLabel;
/// 中间文案
@property (nonatomic, strong) UILabel *centerLabel;

@end

@implementation YCJComplaintDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJComplaintDetailCell *cell = (YCJComplaintDetailCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
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

- (void)detailModel:(YCJComplaintDetailModel *)detail index:(NSInteger)index {
    if (index == 0) {
        self.topLabel.text = @"申诉理由";
    } else {
        self.topLabel.text = @"申诉结果";
    }
    if (detail.appeal) {
        if (index == 0) {
            self.centerLabel.text = detail.appeal.reason;
        } else {
            NSString *statusString = @"";
            UIColor *textColor = kCommonBlackColor;
            if (detail.status == 1) {
                /// 申诉成功
                statusString = @"申诉成功";
                textColor = kColorHex(0x21A22E);
            } else if (detail.status == 2) {
                /// 申诉失败
                statusString = @"申诉失败";
                textColor = kCommonBlackColor;
            }
            self.centerLabel.text = statusString;
            self.centerLabel.textColor = textColor;
        }
    }
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.topLabel];
    [self.containView addSubview:self.centerLabel];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(kSize(84));
        make.top.mas_equalTo(kSize(15));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(15));
        make.top.mas_equalTo(kSize(15));
        make.height.mas_equalTo(kSize(20));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.top.equalTo(self.topLabel.mas_bottom).offset(kSize(8));
        make.height.mas_equalTo(kSize(20));
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
        _centerLabel.font = kPingFangRegularFont(14);
        _centerLabel.textColor = kCommonBlackColor;
        _centerLabel.text = @"";
        _centerLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _centerLabel;
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
