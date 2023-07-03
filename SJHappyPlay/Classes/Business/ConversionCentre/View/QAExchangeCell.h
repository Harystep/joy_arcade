

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QAExchangeModel;
@interface QAExchangeCell : UICollectionViewCell
/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier;
/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic, strong) QAExchangeModel *exchangeModel;
@end

NS_ASSUME_NONNULL_END
