//
//  YCJGameRecordCell.h
//  YCJieJiGame
//
//  Created by John on 2023/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJGameRecordModel, YCJComplaintModel;
@interface YCJGameRecordCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) YCJGameRecordModel *gameRecordModel;
@property(nonatomic, strong) YCJComplaintModel *comModel;
@end

NS_ASSUME_NONNULL_END
