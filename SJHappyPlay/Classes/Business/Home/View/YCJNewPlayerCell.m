

#import "YCJNewPlayerCell.h"
#import "KMNewPlayerModel.h"

@interface YCJNewPlayerCell ()
@property (nonatomic, strong) UIView *containView;
/// 左边文案
@property (nonatomic, strong) UILabel *topLabel;

/// 中间背景图
@property (nonatomic, strong) UIImageView *contentImageView;
/// 播放图标
@property (nonatomic, strong) UIImageView *playImgView;

@end

@implementation YCJNewPlayerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    YCJNewPlayerCell *cell = (YCJNewPlayerCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
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

- (void)setPlayModel:(KMNewPlayerModel *)playModel {
    self.topLabel.text = playModel.title;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:playModel.thumb]];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.topLabel];
    [self.containView addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.playImgView];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(-kMargin);
        make.height.mas_equalTo(kSize(210));
        make.top.mas_equalTo(kSize(15));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(15));
        make.right.mas_equalTo(-kSize(15));
        make.top.mas_equalTo(kSize(15));
        make.height.mas_equalTo(kSize(20));
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(20));
        make.right.mas_equalTo(-kSize(20));
        make.top.equalTo(self.topLabel.mas_bottom).offset(kSize(15));
        make.height.mas_equalTo(kSize(190));
    }];
    
    [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentImageView);
        make.size.mas_equalTo(kSize(44));
    }];
}

#pragma mark -
#pragma mark -- lazy
- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.cornerRadius = kSize(6);
        _containView.backgroundColor = [UIColor clearColor];
    }
    return _containView;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = kPingFangRegularFont(18);
        _topLabel.textColor = kCommonWhiteColor;
        _topLabel.text = @"";
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.cornerRadius = kSize(4);
    }
    return _contentImageView;
}


- (UIImageView *)playImgView{
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.image = [UIImage imageNamed:@"icon_home_bofang"];
    }
    return _playImgView;
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
