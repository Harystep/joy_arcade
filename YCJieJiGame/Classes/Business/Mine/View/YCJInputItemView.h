//
//  YCJInputItemView.h
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/22.
//

#import "YCJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJInputItemView : YCJBaseView

+ (UIView *)createFieldViewWithLeftIcon:(NSString *)leftIcon rightView:(UIView *)rightView textField:(UITextField *)textField;

+ (UIView *)createFieldViewWithLeftView:(UIView *)leftView rightView:(UIView *)rightView textField:(UITextField *)textField;

+ (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder;


@end

NS_ASSUME_NONNULL_END
