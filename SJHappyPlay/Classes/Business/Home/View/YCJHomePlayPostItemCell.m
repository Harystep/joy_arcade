//
//  YCJHomePlayPostItemCell.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJHomePlayPostItemCell.h"

@interface YCJHomePlayPostItemCell ()

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIImageView *posterIv;

@property (nonatomic,strong) UILabel *posterNameL;

@property (nonatomic,strong) UIButton *opBtn;

@property (nonatomic,strong) UIImageView *playIv;

@end

@implementation YCJHomePlayPostItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)HomePlayPostItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    YCJHomePlayPostItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCJHomePlayPostItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.titleL = [self createSimpleLabelWithTitle:ZCLocalizedString(@"科幻机甲完美重现，高沉浸感体验", nil) font:14 bold:YES color:kCommonWhiteColor];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
    }];
    self.titleL.numberOfLines = 0;
    
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(8);
        make.height.mas_equalTo(kSize(161));
    }];
    self.iconIv.backgroundColor = UIColor.whiteColor;
    [self.iconIv setViewCornerRadiu:8];
    self.iconIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(opBtnClick)];
    [self.iconIv addGestureRecognizer:tap];
    
    UIView *posterView = [[UIView alloc] init];
    [self.contentView addSubview:posterView];
    [posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kSize(22));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(5);
    }];
    posterView.backgroundColor = rgba(87, 113, 175, 1);
    [posterView setViewCornerRadiu:kSize(11)];
    
    self.posterIv = [[UIImageView alloc] init];
    [posterView addSubview:self.posterIv];
    [self.posterIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(kSize(18));
        make.leading.mas_equalTo(posterView.mas_leading).offset(2);
        make.centerY.mas_equalTo(posterView.mas_centerY);
    }];
    [self.posterIv setViewCornerRadiu:kSize(9)];
    self.posterIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    self.posterNameL = [self createSimpleLabelWithTitle:ZCLocalizedString(@"我的世界", nil) font:12 bold:NO color:kCommonWhiteColor];
    [posterView addSubview:self.posterNameL];
    [self.posterNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(posterView.mas_centerY);
        make.leading.mas_equalTo(self.posterIv.mas_trailing).offset(5);
        make.trailing.mas_equalTo(posterView.mas_trailing).inset(8);
    }];
        
    self.opBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.opBtn];
    [self.opBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(posterView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.width.height.mas_equalTo(30);
    }];
    [self.opBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.playIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_bofang"]];
    [self.iconIv addSubview:self.playIv];
    self.playIv.hidden = YES;
    [self.playIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv);
        make.centerY.mas_equalTo(self.iconIv);
    }];
    
}

- (void)opBtnClick {
    NSDictionary *dataDic = self.dataDic;
    NSURL *url = [NSURL URLWithString:kSafeContentString(dataDic[@"path"])];
    AVPlayerItem *playerItem  = [AVPlayerItem playerItemWithURL:url];
    AVPlayer     *player      = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
    playerVc.player = player;
    playerVc.title  = kSafeContentString(dataDic[@"title"]);
    [self.parentController presentViewController:playerVc animated:YES completion:nil];
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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = dataDic[@"title"];
    self.posterNameL.text = [NSString stringWithFormat:@"%@ > ", dataDic[@"groupName"]];
    NSString *videoUrl = kSafeContentString(dataDic[@"path"]);//视频
    NSString *media = kSafeContentString(dataDic[@"media"]);//图片
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
}

@end
