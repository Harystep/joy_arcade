//
//  YCJGameRoomCell.h
//  YCJieJiGame
//
//  Created by John on 2023/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YCJRoomListModel;
@interface YCJGameRoomCell : UICollectionViewCell
/* 方块视图的缓存池标示 */
+ (NSString *)cellIdentifier;
/* 获取方块视图对象 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic, strong) YCJRoomListModel *roomModel;
@end

NS_ASSUME_NONNULL_END
