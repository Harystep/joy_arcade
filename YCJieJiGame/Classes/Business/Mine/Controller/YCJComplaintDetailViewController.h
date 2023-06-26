//
//  YCJComplaintDetailViewController.h
//  YCJieJiGame
//
//  Created by John on 2023/5/22.
//

#import "YCJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
///申诉详情
@class YCJComplaintModel;
@interface YCJComplaintDetailViewController : YCJBaseViewController
@property(nonatomic, strong) YCJComplaintModel *comModel;
@end

NS_ASSUME_NONNULL_END
