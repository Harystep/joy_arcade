//
//  YCJSigninContentView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/25.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class YCJSignInListModel, YCJSignInDetailModel;
@interface YCJSigninContentView : YCJBaseView
@property (nonatomic, strong) YCJSignInDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
