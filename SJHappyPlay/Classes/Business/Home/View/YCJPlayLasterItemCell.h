//
//  YCJPlayLasterItemCell.h
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJPlayLasterItemCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataArr;

+ (instancetype)playLasterItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
