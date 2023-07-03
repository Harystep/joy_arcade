

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJComplaintModel;
@interface YCJComplainRecordCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong) YCJComplaintModel *comModel;
@end

NS_ASSUME_NONNULL_END
