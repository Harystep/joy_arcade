

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJConsumeModel;
@interface YCJJinBiCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YCJConsumeModel *consumeModel;
@end

NS_ASSUME_NONNULL_END
