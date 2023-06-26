//
//  YCJComplaintDetailCell.h
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import <UIKit/UIKit.h>
#import "YCJComplaintModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YCJComplaintDetailCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
- (void)detailModel:(YCJComplaintDetailModel *)detail index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
