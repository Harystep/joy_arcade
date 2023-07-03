

#import "QABaseView.h"
#import "YCJGameRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJComplaintReasonAlertView : QABaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property(nonatomic, strong) YCJGameRecordModel *gameModel;
@property(nonatomic, strong) YCJGameDetailModel *detailModel;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
