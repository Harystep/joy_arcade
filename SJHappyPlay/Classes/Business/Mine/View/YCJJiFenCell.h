

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJConsumeModel;
@interface YCJJiFenCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YCJConsumeModel *jifenModel;
@end

NS_ASSUME_NONNULL_END
