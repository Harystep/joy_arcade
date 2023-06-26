//
//  YCJRankListModel.h
//  YCJieJiGame
//
//  Created by zza on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJRankListModel : NSObject
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, assign) NSInteger hasRank;

@end

NS_ASSUME_NONNULL_END
