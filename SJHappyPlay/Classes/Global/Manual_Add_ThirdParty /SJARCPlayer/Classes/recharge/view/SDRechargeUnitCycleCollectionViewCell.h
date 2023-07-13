//
//  SDRechargeUnitCycleCollectionViewCell.h
//  wawajiGame
//
//  Created by sander shan on 2022/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDRechargeUnitDataModel;
@interface SDRechargeUnitCycleCollectionViewCell : UICollectionViewCell

- (void)loadDataModel:(SDRechargeUnitDataModel * )model;

@end

NS_ASSUME_NONNULL_END
