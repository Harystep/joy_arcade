

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJConsumeModel;
@interface YCJZuanShiCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YCJConsumeModel *zuanShiModel;
@end

NS_ASSUME_NONNULL_END
