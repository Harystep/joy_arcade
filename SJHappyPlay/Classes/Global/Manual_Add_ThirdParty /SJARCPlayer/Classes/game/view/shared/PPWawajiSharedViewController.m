#import "PPWawajiSharedViewController.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "PPImageUtil.h"
#import "PPGameConfig.h"
#define shareTitle @"决战万圣夜·夹娃娃"
#define appDownLink @"http://h5.ssjww100.com/#/download"
#define sharedImage @"http://image.kduoo.com/1629170724596.png"
#define sharedMessage @"决战万圣夜，疯狂魔鬼城，在线夹娃娃...更多精彩玩法等你来"

#import "AppDefineHeader.h"

@interface PPWawajiSharedViewController ()
@property (nonatomic, weak) UIView * theBgView;
@property (nonatomic, weak) UILabel * theTitleLabel;
@property (nonatomic, weak) UIButton * theWechatSharedButton;
@property (nonatomic, weak) UIButton * theWechatsharedLineButton;
@end
@implementation PPWawajiSharedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  [self configView];
}
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.theBgView mas_updateConstraints:^(MASConstraintMaker *make) {
      if (@available(iOS 11.0, *)) {
          make.height.mas_equalTo((DSize(400) + self.view.safeAreaInsets.bottom));
      } else {
          // Fallback on earlier versions
          make.height.mas_equalTo(DSize(400));
      }
  }];
  CAShapeLayer * layer = [CAShapeLayer layer];
  UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, DSize(400) + self.view.safeAreaInsets.bottom) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(DSize(20), DSize(20))];
  layer.path = path.CGPath;
  layer.fillColor = [UIColor whiteColor].CGColor;
  self.theBgView.layer.mask = layer;
}
- (void)configView {
  [self theBgView];
  [self theTitleLabel];
  [self theWechatSharedButton];
  [self theWechatsharedLineButton];
}
#pragma mark - action
- (void)onSharedPress:(id)sender {
  [self dismissViewControllerAnimated:false completion:^{
  }];
    [[PPGameConfig sharedInstance] onShareWechatWithApp];
}
- (void)onSharedScenePress:(id)sender {
  [self dismissViewControllerAnimated:false completion:^{
  }];
    [[PPGameConfig sharedInstance] onShareWechatSceneWithApp];
}
- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
- (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); 
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    if (data.length > maxLength) {
        return [self compressImage:resultImage toByte:maxLength];
    }
    return data;
}
#pragma mark - lazy
- (UIView * )theBgView{
  if (!_theBgView) {
    UIView * theView = [[UIView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.bottom.equalTo(self.view);
      make.right.equalTo(self.view);
      make.height.mas_equalTo(DSize(400));
    }];
    theView.backgroundColor = [UIColor whiteColor];
    _theBgView = theView;
  }
  return _theBgView;
}
- (UILabel * )theTitleLabel{
  if (!_theTitleLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theBgView);
      make.top.equalTo(self.theBgView).offset(DSize(69));
    }];
      theView.font = AutoPxFont(28);
    theView.textColor = [UIColor colorForHex:@"#999999"];
    theView.text = @"选择分享方式";
    _theTitleLabel = theView;
  }
  return _theTitleLabel;
}
- (UIButton * )theWechatSharedButton{
  if (!_theWechatSharedButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theBgView.mas_centerX).offset(DSize(-100));
      make.width.mas_equalTo(DSize(100));
      make.height.mas_equalTo(DSize(100));
      make.top.equalTo(self.theTitleLabel.mas_bottom).offset(DSize(50));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_shared_wechat"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onSharedPress:) forControlEvents:UIControlEventTouchUpInside];
    _theWechatSharedButton = theView;
  }
  return _theWechatSharedButton;
}
- (UIButton * )theWechatsharedLineButton{
  if (!_theWechatsharedLineButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self.theBgView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.theBgView.mas_centerX).offset(DSize(100));
      make.width.mas_equalTo(DSize(100));
      make.height.mas_equalTo(DSize(100));
      make.top.equalTo(self.theTitleLabel.mas_bottom).offset(DSize(50));
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_shared_wechat_scene"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onSharedScenePress:) forControlEvents:UIControlEventTouchUpInside];
    _theWechatsharedLineButton = theView;
  }
  return _theWechatsharedLineButton;
}
@end
