//
//  YCJHomeContentView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/29.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^clickCallBack) (NSInteger index);
@class YCJGameRoomModel;
@interface YCJHomeContentView : YCJBaseView

/** 点击图片回调的block */
@property (nonatomic, copy) clickCallBack clickBlcok;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YCJGameRoomModel *gameRoomModel;
@end

NS_ASSUME_NONNULL_END
