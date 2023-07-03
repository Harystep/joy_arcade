

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN
#define GameButtonHeight kSize(65)
typedef void (^clickCallBack) (NSInteger index);
@class YCJGameRoomModel;
@interface KMHomeContentView : QABaseView

/** 点击图片回调的block */
@property (nonatomic, copy) clickCallBack clickBlcok;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YCJGameRoomModel *gameRoomModel;
@end

NS_ASSUME_NONNULL_END
