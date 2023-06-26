//
//  YCJShopModel.h
//  YCJieJiGame
//
//  Created by John on 2023/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJShopCellModel : NSObject
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *iosOption;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *dayMoney;
@property (nonatomic, copy) NSString *buyType;

@end

@interface YCJPaySupport : NSObject
@property (nonatomic, copy) NSString *payMode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *isCheck;
@end

@interface YCJShopModel : NSObject

@property(nonatomic,strong) NSArray<YCJShopCellModel *> *optionList;
@property(nonatomic,strong) NSArray<YCJPaySupport *>    *paySupport;

@end

NS_ASSUME_NONNULL_END
