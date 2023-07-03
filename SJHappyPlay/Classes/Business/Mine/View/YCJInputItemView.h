

#import "QABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJInputItemView : QABaseView

+ (UIView *)createFieldViewWithLeftIcon:(NSString *)leftIcon rightView:(UIView *)rightView textField:(UITextField *)textField;

+ (UIView *)createFieldViewWithLeftView:(UIView *)leftView rightView:(UIView *)rightView textField:(UITextField *)textField;

+ (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder;


@end

NS_ASSUME_NONNULL_END
