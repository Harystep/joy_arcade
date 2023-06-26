//
//  YCJNewPlayerCell.h
//  YCJieJiGame
//
//  Created by zza on 2023/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJNewPlayerModel;
@interface YCJNewPlayerCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YCJNewPlayerModel *playModel;
@end

NS_ASSUME_NONNULL_END
