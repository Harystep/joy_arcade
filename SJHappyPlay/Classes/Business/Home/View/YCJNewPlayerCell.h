

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KMNewPlayerModel;
@interface YCJNewPlayerCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) KMNewPlayerModel *playModel;
@end

NS_ASSUME_NONNULL_END
