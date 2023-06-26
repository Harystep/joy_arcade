//
//  YCJConsumeModel.h
//  YCJieJiGame
//
//  Created by John on 2023/6/13.
//

#import <Foundation/Foundation.h>

#define YCJConsumeTypeModiyNotification @"YCJConsumeTypeModiyNotification"

NS_ASSUME_NONNULL_BEGIN
@interface YCJConsumeModel : NSObject
@property(nonatomic, copy) NSString     *money;
@property(nonatomic, assign) NSInteger  type;
@property(nonatomic, assign) NSInteger  source;
@property(nonatomic, copy) NSString     *remark;
@property(nonatomic, copy) NSString     *createTime;
@end

NS_ASSUME_NONNULL_END
