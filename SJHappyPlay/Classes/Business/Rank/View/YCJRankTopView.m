

#import "YCJRankTopView.h"
#import "YCJRankContentView.h"


@interface YCJRankTopView()
///内容视图
@property (nonatomic, strong) UIView             *contentView;
/// 头像
@property (nonatomic, strong) UIImageView        *topImageView;
@property (nonatomic, strong) YCJRankContentView *contentAView;
@property (nonatomic, strong) YCJRankContentView *contentBView;

@end

@implementation YCJRankTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setRankModel:(YCJRankListModel *)rankModel {
    [self.contentAView setRankModel:rankModel type:1];
}

- (void)setCaifuModel:(YCJRankListModel *)caifuModel {
    [self.contentBView setRankModel:caifuModel type:2];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    [self.contentView addSubview:self.topImageView];
//    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.height.mas_equalTo(0.01);
//    }];
//    self.topImageView.hidden = YES;
    
    [self.contentView addSubview:self.contentAView];
    [self.contentView addSubview:self.contentBView];
    [self.contentAView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
//        make.top.equalTo(self.contentView).offset(60);
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(60);
    }];
    
    [self.contentBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.equalTo(self.contentAView.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topImageView.image = [UIImage imageNamed:[NSString convertImageNameWithLanguage:@"icon_phb_month_en"]];
        _topImageView.layer.masksToBounds = YES;
    }
    return _topImageView;
}

- (YCJRankContentView *)contentAView {
    if (!_contentAView) {
        _contentAView = [[YCJRankContentView alloc] init];
        _contentAView.cornerRadius = 12;
    }
    return _contentAView;
}

- (YCJRankContentView *)contentBView {
    if (!_contentBView) {
        _contentBView = [[YCJRankContentView alloc] init];
        _contentBView.cornerRadius = 12;
    }
    return _contentBView;
}

@end
