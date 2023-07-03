

#import "QABaseViewController.h"
#import "YCJGameRoomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KMGameRoomViewController : QABaseViewController
@property (nonatomic, strong) YCJGameRoomGroup *roomGroup;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
