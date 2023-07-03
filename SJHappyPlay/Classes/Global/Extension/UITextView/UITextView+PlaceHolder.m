//
//  UITextView+PlaceHolder.m
//  Psychosis
//
//  Created by lang on 2019/2/20.
//  Copyright © 2019 cnovit. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kTextViewPlacehodeTag   1111

@implementation UITextView (PlaceHolder)

- (void)setTextViewPlaceHolder:(NSString *)placeHolder{
    // 通过运行时，发现UITextView有一个叫做“_placeHolderLabel”的私有变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextView class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *objcName = [NSString stringWithUTF8String:name];
        NSLog(@"%d : %@",i,objcName);
    }
    
    [self setupTextView:placeHolder];
}

- (void)setupTextView:(NSString *)placeHolder{
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeHolder;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = kColorRGB(200, 201, 203);
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    
    placeHolderLabel.font = self.font;
    
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)setTextViewPlaceHolder:(NSString *)placeHolder font:(NSInteger)fontsize {
    UILabel *plabel = [self viewWithTag:kTextViewPlacehodeTag];
    if (plabel) {
        [plabel removeFromSuperview];
    }
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeHolder;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = kColorHex(0x999999);
    [placeHolderLabel sizeToFit];
    placeHolderLabel.font = kPingFangLightFont(fontsize);
    placeHolderLabel.tag = kTextViewPlacehodeTag;
    [self addSubview:placeHolderLabel];
    
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}


@end
