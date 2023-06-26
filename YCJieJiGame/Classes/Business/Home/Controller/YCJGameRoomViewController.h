//
//  YCJGameRoomViewController.h
//  YCJieJiGame
//
//  Created by John on 2023/6/5.
//

#import "YCJBaseViewController.h"
#import "YCJGameRoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCJGameRoomViewController : YCJBaseViewController
@property (nonatomic, strong) YCJGameRoomGroup *roomGroup;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
