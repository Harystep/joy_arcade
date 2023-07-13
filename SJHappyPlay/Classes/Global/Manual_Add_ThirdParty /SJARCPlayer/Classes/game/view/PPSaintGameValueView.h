#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
  SDGameValue_Coin,
  SDGameValue_point,
} SDGameValueType;
NS_ASSUME_NONNULL_BEGIN
@interface PPSaintGameValueView : UIControl
@property (nonatomic, assign) SDGameValueType valueType;
@property (nonatomic, assign) NSInteger gameValue;
- (instancetype)initWithValueType:(SDGameValueType)type;
- (instancetype)initWithForGoldLegendValueType:(SDGameValueType)type;
@end
NS_ASSUME_NONNULL_END
