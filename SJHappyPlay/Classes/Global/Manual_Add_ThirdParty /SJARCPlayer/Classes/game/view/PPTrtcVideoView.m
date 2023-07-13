#import "PPTrtcVideoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "AppDefineHeader.h"
@interface PPTrtcVideoView ()<WsRTCLiveViewDelegate>
@property (nonatomic, weak) UIImageView * theDefineImageView;
@property (nonatomic, assign) Boolean mute;
@end
@implementation PPTrtcVideoView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.mute = false;
    [self theDefineImageView];
  }
  return self;
}
#pragma mark - public
- (void)loadDefineVideoImageUrl:(NSString * )imageUrl {
  @weakify_self;
  [self.theDefineImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    @strongify_self;
    CGSize imageSize = image.size;
    CGFloat imageOption = 4.0f / 3.0f;
    CGFloat imageHeight = self.frame.size.width / imageOption;
    self.theDefineImageView.image = image;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.theDefineImageView.frame = CGRectMake(0, -(imageHeight - self.frame.size.height) /2.0f, self.frame.size.width, imageHeight);
    });
  }];
}
- (void)loadFullVideoImageUrl:(NSString * )imageUrl {
  self.theDefineImageView.contentMode = UIViewContentModeScaleToFill;
  [self.theDefineImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)startStreamUrl:(NSString *)streamUrl {
  _streamUrl = streamUrl;
  self.vidoeView.streamUrl = self.streamUrl;
  [self.vidoeView startplay];
}
- (void)startStreamUrlWithFFmpegAudio:(NSString *)streamUrl {
  self.mute = true; //推流是否静音
  [self startStreamUrl:streamUrl];
}
- (void)stopStreamVideo {
  [self.vidoeView stop];
}

- (void)pause {
    [self.vidoeView pause];
}

- (void)resume {
//    [self.vidoeView setAudioMute:true];
    [self.vidoeView restart];
}
#pragma mark - WsRTCLiveViewDelegate
- (void)videoView:(WsRTCLiveView *)videoView didError:(NSError *)error {
  NSLog(@"videoView didError: %@", error);
}
- (void)videoView:(WsRTCLiveView *)videoView didChangeVideoSize:(CGSize)size {
}
- (void)onConnected:(WsRTCLiveView *)videoView {
  if (self.mute) {
    [videoView setAudioMute:true];
  }
}
#pragma mark - lazy weak View
- (UIImageView *)theDefineImageView{
    if (!_theDefineImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        theView.contentMode = UIViewContentModeScaleAspectFill;
        _theDefineImageView = theView;
    }
    return _theDefineImageView;
}
- (WsRTCLiveView *)vidoeView{
  if (!_vidoeView) {
      WsRTCLiveView * theView = [[WsRTCLiveView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) audioforamt:WsRTCAudio_AAC_LATM encrypt:false];
    [self addSubview:theView];
    theView.delegate = self;
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self);
    }];
    _vidoeView = theView;
  }
  return _vidoeView;
}
@end
