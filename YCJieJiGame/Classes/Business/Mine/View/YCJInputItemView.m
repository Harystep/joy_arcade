//
//  YCJInputItemView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/22.
//

#import "YCJInputItemView.h"

@implementation YCJInputItemView

+ (UIView *)createFieldViewWithLeftIcon:(NSString *)leftIcon rightView:(UIView *)rightView textField:(UITextField *)textField {
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:leftIcon];
    iconView.frame = CGRectMake(0, 0, kSize(24), kSize(24));
    return [self createFieldViewWithLeftView:iconView rightView:rightView textField:textField];
}

+ (UIView *)createFieldViewWithLeftView:(UIView *)leftView rightView:(UIView *)rightView textField:(UITextField *)textField  {
    UIView *fieldView = [[UIView alloc] init];
    if(leftView) {
        [fieldView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fieldView);
            make.bottom.equalTo(fieldView).offset(-kSize(14));
            make.size.mas_equalTo(leftView.size);
        }];
    }
    
    if(rightView) {
        [fieldView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(leftView);
            make.size.mas_equalTo(rightView.size);
        }];
    }
 
    [fieldView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fieldView);
        make.centerY.equalTo(leftView);
        if(leftView) {
            make.left.equalTo(leftView.mas_right).offset(kSize(10));
        }else {
            make.left.equalTo(fieldView);
        }
        if(rightView) {
            make.right.equalTo(rightView.mas_left).offset(kSize(-10));
        }else {
            make.right.equalTo(fieldView);
        }
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [fieldView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(fieldView);
        make.height.mas_equalTo(0.5);
    }];
    return fieldView;
}

+ (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = kPingFangRegularFont(14);
    textfield.textColor = kCommonBlackColor;
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: kShallowBlackColor}];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.keyboardType = UIKeyboardTypeASCIICapable;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield.spellCheckingType = UITextSpellCheckingTypeNo;
    textfield.enablesReturnKeyAutomatically = YES;
    UIButton *clearBtn = [textfield valueForKey:@"_clearButton"];
    [clearBtn setImage:[UIImage imageNamed:@"textfield_clear"]forState:UIControlStateNormal];
    return textfield;
}

@end
