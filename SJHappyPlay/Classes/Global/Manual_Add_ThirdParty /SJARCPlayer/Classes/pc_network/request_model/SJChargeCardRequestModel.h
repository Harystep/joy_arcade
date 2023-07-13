//
//  SJChargeCardRequestModel.h
//  wawajiGame
//
//  Created by sander shan on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "PPRequestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJChargeCardRequestModel : PPRequestBaseModel
@property (nonatomic, assign) NSString *  tradeType;
@property (nonatomic, assign) NSString *  cardId;
@property (nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
