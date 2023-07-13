

#import <UIKit/UIKit.h>
#import "PPChargetCoinData.h"
NS_ASSUME_NONNULL_BEGIN

@interface SJRechargeCoinCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PPChargetCoinData * chargetCointData;
- (void)loadCoinModel:(PPChargetCoinData * )data;

@end

NS_ASSUME_NONNULL_END
