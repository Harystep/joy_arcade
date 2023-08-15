//
//  YCJPosterDetailController.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJPosterDetailController.h"
#import <AVKit/AVKit.h>
#import "YCJAccountLogoutAlertView.h"

@interface YCJPosterDetailController ()

@property (nonatomic,strong) UIImageView *avarIv;

@property (nonatomic,strong) UILabel *usernameL;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *praiseL;

@property (nonatomic,strong) UIImageView *playIv;

@property (nonatomic,strong) UIButton *forceBtn;

@property (nonatomic,copy) NSString *memberId;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) UIButton *praiseBtn;

@end

@implementation YCJPosterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCommonWhiteColor;
    [self bgImageName:@"icon_mine_bg"];
    [self createUI];
    [self requestDetailInfo];
}

- (void)createUI {
    UIScrollView *scView = [[UIScrollView alloc] init];
    [self.view addSubview:scView];
    [scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kStatusBarPlusNaviBarHeight);
    }];
    self.contentView = [[UIView alloc] init];
    [scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scView);
        make.width.mas_equalTo(scView.mas_width);
    }];
    self.avarIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avarIv];
    [self.avarIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.leading.top.mas_equalTo(self.contentView).offset(12);
    }];
    [self.avarIv setViewCornerRadiu:16];
    self.avarIv.backgroundColor = rgba(216, 216, 216, 1);
    
    self.usernameL = [self.view createSimpleLabelWithTitle:@" " font:13 bold:NO color:kCommonWhiteColor];
    [self.contentView addSubview:self.usernameL];
    [self.usernameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(self.avarIv.mas_top);
        make.leading.mas_equalTo(self.avarIv.mas_trailing).offset(8);
    }];
    
    self.timeL = [self.view createSimpleLabelWithTitle:@" " font:10 bold:NO color:rgba(255, 255, 255, 0.6)];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avarIv.mas_trailing).offset(8);
        make.top.mas_equalTo(self.usernameL.mas_bottom).offset(2);
        make.height.mas_equalTo(14);
    }];
    
    self.titleL = [self.view createSimpleLabelWithTitle:@" " font:16 bold:YES color:kCommonWhiteColor];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.avarIv.mas_bottom).offset(20);
    }];
    self.titleL.numberOfLines = 0;
    
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(12);
        make.height.mas_equalTo(161);
    }];
    [self.iconIv setViewCornerRadiu:8];
    self.iconIv.backgroundColor = rgba(216, 216, 216, 1);
    self.iconIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(opBtnClick)];
    [self.iconIv addGestureRecognizer:tap];
    
    self.contentL = [self.view createSimpleLabelWithTitle:@" " font:14 bold:NO color:kCommonWhiteColor];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(12);
    }];
    self.contentL.numberOfLines = 0;
    
    self.contentL = [self.view createSimpleLabelWithTitle:@" " font:14 bold:NO color:kCommonWhiteColor];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(12);
    }];
    self.contentL.numberOfLines = 0;
    
    self.praiseL = [self.view createSimpleLabelWithTitle:@" " font:12 bold:YES color:rgba(255, 255, 255, 0.6)];
    [self.contentView addSubview:self.praiseL];
    [self.praiseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(12);
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(20);
    }];
    
    self.playIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_bofang"]];
    [self.iconIv addSubview:self.playIv];
    self.playIv.hidden = YES;
    [self.playIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv);
        make.centerY.mas_equalTo(self.iconIv);
    }];
    
    self.forceBtn = [self.view createSimpleButtonWithTitle:[NSString stringWithFormat:@"  %@  ", ZCLocalizedString(@"关注", nil)] font:14 color:kCommonWhiteColor];
    [self.contentView addSubview:self.forceBtn];
    [self.forceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avarIv.mas_centerY);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(12);
    }];
    [self.forceBtn addTarget:self action:@selector(forceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.forceBtn layoutIfNeeded];
    [self.forceBtn setViewBorderWithColor:2 color:rgba(226, 224, 255, 1)];
    [self addGradientLayerWithCorner:self.forceBtn withCornerRadius:6 withLineWidth:4 withColors:@[(id)rgba(166, 181, 255, 1).CGColor,(id)rgba(82, 121, 206, 1).CGColor] start:CGPointMake(0.5, 0) end:CGPointMake(0.5, 1)];
    [self.forceBtn setViewCornerRadiu:6];
    [self.forceBtn setTitle:[NSString stringWithFormat:@"  %@  ", ZCLocalizedString(@"取消关注", nil)] forState:UIControlStateSelected];
    self.forceBtn.hidden = YES;
    
    UIButton *reportBtn = [self.view createSimpleButtonWithTitle:@"···" font:20 color:kCommonWhiteColor];
    [self.contentView addSubview:reportBtn];
    reportBtn.titleLabel.font = kPingFangSemiboldFont(15);
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(12);
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.praiseL.mas_centerY);
    }];
    [reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *praiseBtn = [[UIButton alloc] init];
    [self.contentView addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(60);
        make.centerY.mas_equalTo(self.praiseL.mas_centerY);
    }];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setImage:[UIImage imageNamed:@"game_detail_praise_un"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"game_detail_praise"] forState:UIControlStateSelected];
    self.praiseBtn = praiseBtn;
    
}
#pragma mark - 点赞
- (void)praiseBtnClick {
    
    [JKNetWorkManager postRequestWithUrlPath:JKGameProfilePraiseUrlKey parameters:@{@"dynamicId":kSafeContentString(self.dataDic[@"id"])} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.praiseBtn.selected = YES;
            });
        }
    }];
}
#pragma mark - 举报
- (void)reportBtnClick {
    YCJAccountLogoutAlertView *canAlert = [[YCJAccountLogoutAlertView alloc] init];
    canAlert.type = YCJAccountTypeLogout;
    canAlert.titleLB.text = ZCLocalizedString(@"确定要举报该内容？", nil);
    canAlert.commonAlertViewDoneClickBlock = ^{
        [JKNetWorkManager postRequestWithUrlPath:JKGameProfileReportUrlKey parameters:@{@"dynamicId":kSafeContentString(self.dataDic[@"id"]), @"content":kSafeContentString(self.dataDic[@"content"])} finished:^(JKNetWorkResult * _Nonnull result) {
            [MBProgressHUD showSuccess:ZCLocalizedString(@"已举报", nil)];
        }];
    };
    [canAlert show];
}

#pragma mark - 播放
- (void)opBtnClick {
    NSDictionary *dataDic = self.dataDic;
    NSURL *url = [NSURL URLWithString:kSafeContentString(dataDic[@"path"])];
    AVPlayerItem *playerItem  = [AVPlayerItem playerItemWithURL:url];
    AVPlayer     *player      = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
    playerVc.player = player;
    playerVc.title  = kSafeContentString(dataDic[@"groupName"]);
    [self presentViewController:playerVc animated:YES completion:nil];
}

- (void)forceBtnClick {
    NSString *urlStr;
    if(self.forceBtn.selected) {
        urlStr = JKGameProfileUnForceUrlKey;
    } else {
        urlStr = JKGameProfileForceUrlKey;
    }
    [JKNetWorkManager postRequestWithUrlPath:urlStr parameters:@{@"memberId":kSafeContentString(self.memberId)} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.forceBtn.selected = !self.forceBtn.selected;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.forceBtn layoutIfNeeded];
                [self addGradientLayerWithCorner:self.forceBtn withCornerRadius:6 withLineWidth:4 withColors:@[(id)rgba(166, 181, 255, 1).CGColor,(id)rgba(82, 121, 206, 1).CGColor] start:CGPointMake(0.5, 0) end:CGPointMake(0.5, 1)];
            });
        }
    }];
}

- (void)requestDetailInfo {
    [JKNetWorkManager postRequestWithUrlPath:JKGameProfileDetailUrlKey parameters:@{@"gameInfoId":kSafeContentString(self.gameInfoId)} finished:^(JKNetWorkResult * _Nonnull result) {
        if (result.error) {
            [MBProgressHUD showError:result.error.localizedDescription];
        } else {
            NSDictionary *dataDic = result.resultData;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.memberId = dataDic[@"memberId"];
                [self configureSubviews:dataDic];
            });
        }
    }];
}

- (void)configureSubviews:(NSDictionary *)dataDic {
    self.dataDic = dataDic;
    self.forceBtn.hidden = NO;
    self.usernameL.text = kSafeContentString(dataDic[@"groupName"]);
    self.timeL.text = kSafeContentString(dataDic[@"createTime"]);
    self.titleL.attributedText = [NSString setAttributeStringContent:kSafeContentString(dataDic[@"title"]) space:5 font:kPingFangSemiboldFont(16) alignment:NSTextAlignmentLeft];
    NSString *videoUrl = kSafeContentString(dataDic[@"path"]);//视频
    NSString *media = kSafeContentString(dataDic[@"media"]);//图片
    self.forceBtn.selected = [kSafeContentString(dataDic[@"hasFocus"]) integerValue];
    if(videoUrl.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconIv.image = [self getVideoPreViewImage:[NSURL URLWithString:media]];
        });
        self.playIv.hidden = NO;
    } else {
        self.playIv.hidden = YES;
        if(media.length > 0) {
            NSArray *picArr = [media componentsSeparatedByString:@","];
            [self.iconIv sd_setImageWithURL:[NSURL URLWithString:picArr.firstObject] placeholderImage:nil];
        }
    }
    if([kSafeContentString(dataDic[@"hasLike"]) integerValue] == 1) {
        self.praiseBtn.userInteractionEnabled = NO;
    }
    self.praiseBtn.selected = [kSafeContentString(dataDic[@"hasLike"]) integerValue];
    self.contentL.attributedText = [NSString setAttributeStringContent:kSafeContentString(dataDic[@"content"]) space:5 font:kPingFangLightFont(14) alignment:NSTextAlignmentLeft];
    self.praiseL.text = [NSString stringWithFormat:@"%@%@", kSafeContentString(dataDic[@"likeNum"]), ZCLocalizedString(@"点赞", nil)];
}

// 获取视频第一帧
- (UIImage*)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(5, 6);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)addGradientLayerWithCorner:(UIView *)view withCornerRadius:(float)cornerRadius withLineWidth:(float)lineWidth withColors:(NSArray *)colors start:(CGPoint)point1 end:(CGPoint)point2 {
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    gradientLayer.colors = colors;
    gradientLayer.startPoint = point1;
    gradientLayer.endPoint = point2;
    gradientLayer.cornerRadius = cornerRadius;
        
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

@end
