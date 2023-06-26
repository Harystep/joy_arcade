//
//  YCJGameDetailViewController.h
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJBaseViewController.h"
#import "YCJGameRecordModel.h"

NS_ASSUME_NONNULL_BEGIN
///游戏记录详情
@interface YCJGameDetailViewController : YCJBaseViewController
@property (nonatomic, strong) YCJGameRecordModel *gameModel;
@end

NS_ASSUME_NONNULL_END
