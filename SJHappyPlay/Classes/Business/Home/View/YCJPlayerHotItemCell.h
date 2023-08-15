//
//  YCJPlayerHotItemCell.h
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import <UIKit/UIKit.h>
#import "YCJGameRoomModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface YCJPlayerHotItemCell : UITableViewCell

@property (nonatomic,strong) YCJGameRoomGroup    *roomModel;

+ (instancetype)playerHotItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
