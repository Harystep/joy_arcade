//
//  YCJHomeLeftView.m
//  YCJieJiGame
//
//  Created by ITACHI on 2023/5/25.
//

#import "YCJHomeLeftView.h"
#import "YCJHomeSigninAlertView.h"
#import "YCJSignInListModel.h"
#import "YCJInvitationViewController.h"
#import "YCJNewPlayerViewController.h"
#import "YCJLoginViewController.h"

@interface YCJHomeLeftView()
@property (nonatomic, strong) UIView            *contentView;
@property (nonatomic, strong) NSMutableArray    *dataArr;
@end

@implementation YCJHomeLeftView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
 
    for (int index = 0; index < self.dataArr.count; index ++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString convertImageNameWithLanguage:self.dataArr[index]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index;
        [self.contentView addSubview:btn];
        btn.imageView.contentMode = UIViewContentModeCenter;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kMargin);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(50);
            make.top.mas_equalTo(kSize(85 * index));
            if (index == self.dataArr.count - 1) {
                make.bottom.equalTo(self.contentView);
            }
        }];
    }
}

- (void)showSignInAlertView {
    [JKNetWorkManager getRequestWithUrlPath:JKSigninListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
        if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
            YCJSignInListModel *signModel = [YCJSignInListModel mj_objectWithKeyValues:result.resultData];
            YCJHomeSigninAlertView *sign = [[YCJHomeSigninAlertView alloc] init];
            [sign setListModel:signModel];
            [sign show];
            WeakSelf;
            sign.jumpLoginBlock = ^{
                YCJLoginViewController *vc = [[YCJLoginViewController alloc] init];
                [weakSelf.parentController.navigationController pushViewController:vc animated:YES];
                
            };
        }
    }];
}

- (void)btnAction:(UIButton *)send {
    NSLog(@"%ld", send.tag);
    if (send.tag == 0) { // 每日签到
        if ([[YCJUserInfoManager sharedInstance] isLogin:self.parentController]) {
            [JKNetWorkManager getRequestWithUrlPath:JKSigninListUrlKey parameters:@{} finished:^(JKNetWorkResult * _Nonnull result) {
                if(!result.error && [result.resultData isKindOfClass:[NSDictionary class]]) {
                    YCJSignInListModel *signModel = [YCJSignInListModel mj_objectWithKeyValues:result.resultData];
                    YCJHomeSigninAlertView *sign = [[YCJHomeSigninAlertView alloc] init];
                    [sign setListModel:signModel];
                    [sign show];
                }
            }];
        }
    } else if (send.tag == 1) { // 邀请有礼
        if ([[YCJUserInfoManager sharedInstance] isLogin:self.parentController]) {
            YCJInvitationViewController *vc = [[YCJInvitationViewController alloc] init];
            [self.parentController.navigationController pushViewController:vc animated:YES];
        }
    } else if (send.tag == 2) { // 新手指引
        YCJNewPlayerViewController *vc = [[YCJNewPlayerViewController alloc] init];
        [self.parentController.navigationController pushViewController:vc animated:YES];
    } else if (send.tag == 3) { // 在线客服
        if ([[YCJUserInfoManager sharedInstance] isLogin:self.parentController]) {
            YCJBaseWebViewController *web = [[YCJBaseWebViewController alloc] init];
            YCJToken *userToken = [YCJUserInfoManager sharedInstance].userTokenModel;
            web.url = [NSString stringWithFormat:@"%@source=2&token=%@",kCustomerServiceBaseUrl,userToken.accessToken];
            [self.parentController.navigationController pushViewController:web animated:YES];
        }
        
    }
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"icon_home_mrqd",
                                        @"icon_home_yqyl",
                                        @"icon_home_xszd",
//                                        @"icon_home_zxkf"
                                      ]
        ];
    }
    return _dataArr;
}

@end
