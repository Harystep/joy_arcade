//
//  YCJRankCell.h
//  YCJieJiGame
//
//  Created by zza on 2023/5/24.
//

#import <UIKit/UIKit.h>
#import "YCJRankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJRankCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong) YCJRankListModel *rankModel;
@end

NS_ASSUME_NONNULL_END
