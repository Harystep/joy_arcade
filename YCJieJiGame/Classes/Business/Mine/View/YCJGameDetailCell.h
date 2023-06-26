//
//  YCJGameDetailCell.h
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import <UIKit/UIKit.h>
#import "YCJGameRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJGameDetailCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong) YCJGameRecordModel *gameModel;
@property(nonatomic, strong) YCJGameDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
