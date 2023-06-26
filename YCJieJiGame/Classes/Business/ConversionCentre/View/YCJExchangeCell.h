//
//  YCJExchangeCell.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJExchangeModel;
@interface YCJExchangeCell : UICollectionViewCell
/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier;
/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic, strong) YCJExchangeModel *exchangeModel;
@end

NS_ASSUME_NONNULL_END
