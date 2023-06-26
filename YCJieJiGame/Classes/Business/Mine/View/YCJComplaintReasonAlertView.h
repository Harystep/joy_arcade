//
//  YCJComplaintReasonAlertView.h
//  YCJieJiGame
//
//  Created by John on 2023/5/23.
//

#import "YCJBaseView.h"
#import "YCJGameRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJComplaintReasonAlertView : YCJBaseView
@property (nonatomic, copy) dispatch_block_t completed;
@property(nonatomic, copy) void (^commonAlertViewDoneClickBlock)(void);
@property(nonatomic, strong) YCJGameRecordModel *gameModel;
@property(nonatomic, strong) YCJGameDetailModel *detailModel;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
