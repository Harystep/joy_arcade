

#import <UIKit/UIKit.h>
#import "SJGameRoomListInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJChangeRoomItemCell : UITableViewCell

@property (nonatomic,strong) SJGameRoomListInfoModel *model;

+ (instancetype)changeRoomItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
