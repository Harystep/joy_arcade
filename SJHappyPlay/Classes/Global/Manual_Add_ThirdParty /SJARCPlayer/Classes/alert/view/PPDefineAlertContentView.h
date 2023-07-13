#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface PPDefineAlertContentView : UIView
@property (nonatomic, strong) NSString * alertTitle;
@property (nonatomic, strong) NSString * alertMessage;
@property (nonatomic, weak) UILabel * theMessageLabel;
@end
NS_ASSUME_NONNULL_END
