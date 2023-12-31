

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKDefaultButton : UIButton

+ (instancetype)createButtonWithFrame:(CGRect)rect
                                title:(NSString *)title
                                 font:(UIFont *)font
                               target:(id)target
                             selector:(SEL)selector;


@end

NS_ASSUME_NONNULL_END
