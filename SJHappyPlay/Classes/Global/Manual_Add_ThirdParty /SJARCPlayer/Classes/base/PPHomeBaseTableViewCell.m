#import "PPHomeBaseTableViewCell.h"
@implementation PPHomeBaseTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
+ (NSString *)getCellIdentifier
{
    return NSStringFromClass(self);
}
- (void)loadHomeDataModel:(PPHomeBaseDataModel * )model
{
    _dataModel = model;
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
}
- (void)refeshFrame
{
}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, self.height_statistics_cell);
}
- (UITableView *)supertableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
