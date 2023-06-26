//
//  YCJMineListCell.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJMineInfoModel;

@interface YCJMineListCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;


/// 数据model
@property (nonatomic, strong) YCJMineInfoModel *mineInfoModel;

///更新我的资料列表视图
- (void)updateMineInfoListView:(YCJMineInfoModel *)model;

///更新版本信息列表视图
- (void)updateVersionInfoListView:(YCJMineInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
