//
//  UBLCustomGifHeader.m
//  DouYin
//
//  Created by Jordon on 2020/11/14.
//

#import "CustomGifHeader.h"

static const CGFloat OffsetBetweenStateLabelAndAnimationView = 5;//StateLabel 和 AnimationView 之间的间距

/// 下拉刷新动画
@interface CustomGifHeader ()
/// 加载 Json 动画
@property(nonatomic,strong)LOTAnimationView *animationView;
/// 加载过程中中间显示的随机文案
@property(nonatomic,strong)NSString *randomTitle;

@end

@implementation CustomGifHeader

- (void)prepare{
    [super prepare];
    self.animationView.alpha = 1;
    WeakSelf
    self.endRefreshingCompletionBlock = ^{
        StrongSelf
        [strongSelf updateStateLabelText];
    };
    self.stateLabel.font = [UIFont systemFontOfSize:14
                                             weight:UIFontWeightRegular];
    [self updateStateLabelText];
}
// 执行重新给子视图布局的时候
- (void)placeSubviews{
    [super placeSubviews];
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.mj_w = self.stateLabel.mj_textWidth;
    self.stateLabel.center = CGPointMake(self.mj_w / 2.0 + 15, self.mj_h / 2.0 + 0.0);
    self.animationView.mj_x = self.stateLabel.mj_x - OffsetBetweenStateLabelAndAnimationView - self.animationView.mj_w;
    self.animationView.centerY = self.stateLabel.centerY;
}

- (void)beginRefreshing{
    [super beginRefreshing];
}

- (void)endRefreshing{
    [super endRefreshing];
}
// 更新状态文案
- (void)updateStateLabelText{
    [self getRandomTitle];
    [self setTitle:self.randomTitle forState:MJRefreshStateIdle];
    [self setTitle:self.randomTitle forState:MJRefreshStatePulling];
    [self setTitle:self.randomTitle forState:MJRefreshStateRefreshing];
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle: // 刷新完毕
            [self.animationView stop];
            break;
        case MJRefreshStatePulling: // 下拉达到可触发刷新
            [self.animationView play];
            break;
        case MJRefreshStateRefreshing: // 松手可以刷新
            [self.animationView play];
            break;
        case MJRefreshStateWillRefresh:
            break;
        default:
            break;
    }
}
// 获取随机加载文案
- (void)getRandomTitle{
    
    NSMutableArray *textMutArr = NSMutableArray.array;
    [textMutArr addObject:@"快速加载中，不要急"];
    [textMutArr addObject:@"正在快速加载中，不要慌"];
    [textMutArr addObject:@"快马加鞭加载中"];
    
    NSInteger index = arc4random() % textMutArr.count;
    self.randomTitle = textMutArr[index];
}
#pragma mark —— lazyLoad
- (LOTAnimationView *)animationView{
    if (!_animationView) {
//        NSString *filePaths = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
        NSString *filePaths = [[NSBundle mainBundle] pathForResource:@"loadRefresh" ofType:@"json"];
        _animationView = [LOTAnimationView animationWithFilePath:filePaths];
        _animationView.loopAnimation = YES;
        _animationView.size = CGSizeMake(kSize(40), kSize(40));
        [self addSubview:_animationView];
    }return _animationView;
}

@end
