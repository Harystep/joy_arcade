//
//  PCUserExplainInfoRResponseModel.h
//  wawajiGame
//
//  Created by sander shan on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import "PPResponseBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SDUserExplainInfoData;

@interface PCUserExplainInfoRResponseModel : PPResponseBaseModel

@property (nonatomic, strong) SDUserExplainInfoData * data;

@end

@interface SDUserExplainInfoData : NSObject
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat vipPrice;
@end

NS_ASSUME_NONNULL_END
