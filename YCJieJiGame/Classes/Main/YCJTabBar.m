//
//  YCJTabBar.m
//  YCJieJiGame
//
//  Created by John on 2023/5/24.
//

#import "YCJTabBar.h"

@interface YCJTabBar()
/// 背景
@property (nonatomic, strong) UIImageView *tabBgImageView;
/// 选中背景
@property (nonatomic, strong) UIImageView *currentImgView;
@end

@implementation YCJTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.tabBgImageView];
        [self.tabBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setCurrent:(NSInteger)current {
    _current = current;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat width = self.frame.size.width;
    CGFloat height = 49;
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
//    NSArray *titles = @[@"icon_tab_sc", @"icon_tab_dhzx", @"icon_tab_zhuye", @"icon_tab_phb", @"icon_tab_grzs"];
    for (UIControl *button in self.subviews) {
        for (UIControl *view in button.subviews) {
            [view removeFromSuperview];
        }
        if (![button isKindOfClass:[UIControl class]]) continue;
        // 计算按钮的x值        
        CGFloat buttonX = buttonW * index;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        UIImageView *img = [[UIImageView alloc] init];
////        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_txt", titles[index]]];
//        img.contentMode = UIViewContentModeScaleAspectFit;
//        img.frame = CGRectMake(0, 35, buttonW, 18);
//        [button addSubview:img];
//        img.hidden = YES;
        if (index == self.current) {
            [button insertSubview:self.currentImgView atIndex:0];
            [self.currentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(button);
                make.height.mas_equalTo(83);
            }];
        }
        
        // 增加索引
        index++;
    }
}

#pragma mark -
#pragma mark -- lazy load
- (UIImageView *)tabBgImageView{
    if (!_tabBgImageView) {
        _tabBgImageView = [UIImageView new];
        _tabBgImageView.userInteractionEnabled = YES;
        _tabBgImageView.clipsToBounds = YES;
        _tabBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tabBgImageView.image = [UIImage imageNamed:@"icon_tab_bg"];
        _tabBgImageView.layer.masksToBounds = YES;
    }
    return _tabBgImageView;
}

- (UIImageView *)currentImgView {
    if (!_currentImgView) {
        _currentImgView = [UIImageView new];
        _currentImgView.userInteractionEnabled = NO;
        _currentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _currentImgView.image = [UIImage imageNamed:@"icon_tab_selected"];
        _currentImgView.layer.masksToBounds = YES;
    }
    return _currentImgView;
}
@end
