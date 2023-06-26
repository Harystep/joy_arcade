//
//  JKDefaultButton.m
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import "JKDefaultButton.h"

@implementation JKDefaultButton

+ (instancetype)createButtonWithFrame:(CGRect)rect title:(NSString *)title font:(UIFont *)font target:(id)target selector:(SEL)selector {
    JKDefaultButton *button = [[JKDefaultButton alloc] initWithFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    [button configButton];
    return button;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self configButton];
    
}

- (void)configButton {
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundImage:[UIImage imageWithColor:kButtonThemeColor] forState:UIControlStateNormal];
    [self setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    [self setTitleColor:kCommonBlackColor forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.layer.cornerRadius = kSize(8);
    self.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleLabel.font.pointSize];
}



@end

