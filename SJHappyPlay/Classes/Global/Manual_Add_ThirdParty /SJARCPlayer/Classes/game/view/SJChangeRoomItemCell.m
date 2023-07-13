

#import "SJChangeRoomItemCell.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"
#import "UIImageView+WebCache.h"
#import "SJGameRoomListInfoModel.h"

@interface SJChangeRoomItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation SJChangeRoomItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)changeRoomItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SJChangeRoomItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJChangeRoomItemCell" forIndexPath:indexPath];
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
        make.top.leading.trailing.mas_equalTo(self.contentView).inset(DSize(20));
        make.height.mas_equalTo(DSize(200));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    self.iconIv.layer.cornerRadius = 4;
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(SJGameRoomListInfoModel *)model {
    _model = model;    
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];
}

@end
