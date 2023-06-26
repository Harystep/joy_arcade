//
//  YCJConsumeViewController.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/24.
//

#import "YCJConsumeViewController.h"
#import "YCJJinBiViewController.h"
#import "YCJZuanShiViewController.h"
#import "YCJJiFenViewController.h"
#import "YCJConsumeTypeView.h"
#import <JXCategoryView/JXCategoryView.h>

@interface YCJConsumeViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) YCJConsumeTypeView          *typeView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation YCJConsumeViewController

- (NSArray *)titles {
    return @[ZCLocalizedString(@"金币", nil), ZCLocalizedString(@"钻石", nil), ZCLocalizedString(@"积分", nil)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZCLocalizedString(@"消费记录", nil);
    [self bgImageWhite];
    [self configUI];
}

- (void)configUI {
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.titleSelectedColor = kColorHex(0x6984EA);
    self.categoryView.titleColor = kColorHex(0x333333);
    self.categoryView.delegate = self;
    self.categoryView.titles = self.titles;
    self.categoryView.titleFont = kPingFangSemiboldFont(16);
    self.categoryView.titleSelectedFont = kPingFangSemiboldFont(16);
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kColorHex(0x6984EA);
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kSize(235));
        make.top.mas_equalTo(kStatusBarPlusNaviBarHeight + kSize(10));
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.typeView];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.typeView.mas_bottom);
    }];
    // 关联到 categoryView
    self.categoryView.listContainer = self.listContainerView;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if(index == 0) {
        YCJJinBiViewController *jinbiVC = [[YCJJinBiViewController alloc] init];
        return jinbiVC;
    } else if(index == 1) {
        YCJZuanShiViewController *zuanshiVC = [[YCJZuanShiViewController alloc] init];
        return zuanshiVC;
    } else {
        YCJJiFenViewController *jifenVC = [[YCJJiFenViewController alloc] init];
        return jifenVC;
    }
}

- (YCJConsumeTypeView *)typeView {
    if (!_typeView) {
        _typeView = [[YCJConsumeTypeView alloc] init];
    }
    return _typeView;
}

- (UIView *)listView {
    return self.view;
}
@end
