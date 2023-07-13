//
//  SJResponseAppleCreateOrderModel.h
//  wawajiGame
//
//  Created by oneStep on 2023/6/19.
//

#import "PPResponseBaseModel.h"
#import "SJResponseAppleOrderDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJResponseAppleCreateOrderModel : PPResponseBaseModel

@property (nonatomic,strong) SJResponseAppleOrderDataModel *data;

@end

NS_ASSUME_NONNULL_END
