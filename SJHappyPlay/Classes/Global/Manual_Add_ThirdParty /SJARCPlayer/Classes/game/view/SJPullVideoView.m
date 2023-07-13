#import "SJPullVideoView.h"
#import "Masonry.h"
#import "PPUserInfoService.h"
#import "AppDefineHeader.h"
#import "PPAudioPullView.h"
#import "PPImageUtil.h"
#import "PPAudioPullView.h"

#import "AppDefineHeader.h"

#define pullViewWidth 1280.0
#define pullViewHeight 720
#define pullPushCoinViewWidth 1400.0
@interface SJPullVideoView ()
@property (nonatomic, strong) PPAudioPullView * audioPullView;
@property (nonatomic, strong) NSDictionary * streamMap;
@property (nonatomic, weak) UIImageView * theLeftImageView;
@property (nonatomic, weak) UIImageView * theRightImageView;
@end
@implementation SJPullVideoView
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  NSMutableDictionary * map = [NSMutableDictionary dictionaryWithCapacity:0];
  [map setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"wawaji%@",self.machineSn]];
  [map setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"wawaji%@2",self.machineSn]];
  self.streamMap = [map copy];
  [self last_stream_view];
  [self first_stream_view];
  @weakify_self;
  self.backgroundColor = [UIColor blackColor];
}
#pragma mark - public method
- (void)displayVideoViewForFit {
  if (self.pullViewForDevice == SDPullViewForSaint) {
      NSLog(@"------:%f---%f", SCREEN_WIDTH, SCREEH_HEIGHT);
    CGFloat pullwidth = (pullViewWidth / pullViewHeight) * SCREEH_HEIGHT;
    NSLog(@"[部署 视频] width ---> %f", pullwidth);
    [self.first_stream_view mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self);
      if (self.staint_index == 2 || self.staint_index == 3) {
        make.height.mas_equalTo(SCREEH_HEIGHT - 10);
      } else {
        make.height.mas_equalTo(SCREEH_HEIGHT);
      }
      if (pullwidth > SCREEN_WIDTH) {
        make.width.mas_equalTo(SCREEN_WIDTH);
      } else {
        make.width.mas_equalTo(pullwidth);
      }
    }];
    [self theLeftImageView];
    [self theRightImageView];
    //金币传说
  }else if (self.pullViewForDevice == SDPullViewForGoldLegend) {
    CGFloat pullHeight = (pullViewWidth / pullViewHeight) * SCREEN_WIDTH;
    NSLog(@"[部署 视频] height ---> %f", pullHeight);
    [self.first_stream_view mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.width.mas_equalTo(SCREEN_WIDTH);
      if (pullHeight > SCREEH_HEIGHT) {
        make.height.mas_equalTo(SCREEH_HEIGHT);
      } else {
        make.height.mas_equalTo(pullHeight);
      }
    }];
    [self theLeftImageView].image = [PPImageUtil imageNamed:@"ico_push_coin_his"];
    [self theRightImageView].image = [PPImageUtil imageNamed:@"ico_push_coin_his"];
  }
}
- (CGFloat)displayMarginLeftOrRight {
  if (self.pullViewForDevice == SDPullViewForSaint) {
    CGFloat pullwidth = (pullViewWidth / pullViewHeight) * SCREEH_HEIGHT;
    if (pullwidth > SCREEN_WIDTH) {
      return 0;
    } else {
      return (SCREEN_WIDTH - pullwidth) / 2.0;
    }
  }else if (self.pullViewForDevice == SDPullViewForGoldLegend) {
    CGFloat pullHeight = (pullViewWidth / pullViewHeight) * SCREEN_WIDTH;
    if (pullHeight > SCREEH_HEIGHT) {
      return 0;
    } else {
      return (SCREEH_HEIGHT - pullHeight) / 2.0;
    }
  }
  return 0;
}
- (void)loginRoomId:(NSString * )roomId{
  _roomId = roomId;
  self.currentStreamIndex = 1;
    NSLog(@"machineSn--->%@ roomId---->%@", self.machineSn, roomId);    
  [self startPlayStream:[NSString stringWithFormat:@"wwj_zego_stream_%@", self.machineSn]];
}
- (void)setStaint_index:(NSInteger)staint_index {
  _staint_index = staint_index;
  if (_staint_index == 2 || _staint_index == 3) {
    [self.first_stream_view mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.mas_bottom).offset(DSize(-10));
      make.top.equalTo(self).offset(DSize(-10));
    }];
  }else {
    [self.first_stream_view mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self);
      make.top.equalTo(self);
    }];
  }
}
- (void)startPlayStream:(NSString *)streamId {
  NSString * playUrl = [NSString stringWithFormat:@"http://play-test.ssjww100.com/live/%@.sdp", streamId];
    if (self.pullViewForDevice == SDPullViewForWawaji || self.pullViewForDevice == SDPullViewForPushCoin) {
      [self.first_stream_view startStreamUrlWithFFmpegAudio:playUrl];
        if ([PPUserInfoService get_Instance].backGroudMusic) {
            NSString * audioPlayUrl = [NSString stringWithFormat:@"http://play-test.ssjww100.com/live/%@.flv", streamId];
            _audioPullView = [[PPAudioPullView alloc] initWithUrl:audioPlayUrl];
            [self addSubview:self.audioPullView];
        }
    } else {
        if ([PPUserInfoService get_Instance].backGroudMusic) {
            [self.first_stream_view startStreamUrl: playUrl];
        } else {
            [self.first_stream_view startStreamUrlWithFFmpegAudio:playUrl];
        }
    }
}
- (void)leaveRoom {
  [self stopStream];
  [self.first_stream_view stopStreamVideo];
  if (self.audioPullView) {
    [self.audioPullView shutdown];
  }
}
- (void)loadFirstStreamDefaultImageUrl:(NSString * )loadImageUrl {
    NSLog(@"first:%@", loadImageUrl);
  if (self.pullViewForDevice == SDPullViewForSaint) {
    [self.first_stream_view loadDefineVideoImageUrl:loadImageUrl];
  }else if (self.pullViewForDevice == SDPullViewForPushCoin) {
    [self.first_stream_view loadDefineVideoImageUrl:loadImageUrl];
  } else {
    [self.first_stream_view loadFullVideoImageUrl:loadImageUrl];
  }
}
- (void)loadLastStreamDefaultImageUrl:(NSString * )loadImageUrl {
    NSLog(@"last:%@", loadImageUrl);
  if (self.pullViewForDevice == SDPullViewForSaint) {
    [self.last_stream_view loadDefineVideoImageUrl:loadImageUrl];
  }else if (self.pullViewForDevice == SDPullViewForPushCoin) {
    [self.first_stream_view loadDefineVideoImageUrl:loadImageUrl];
  }else {
    [self.last_stream_view loadFullVideoImageUrl:loadImageUrl];
  }
}
- (void)switchGameVideo {
  if (self.currentStreamIndex == 1) {
    self.currentStreamIndex = 2;
    [UIView animateWithDuration:0.1 animations:^{
      self.first_stream_view.alpha = 0;
      self.last_stream_view.alpha = 1;
    } completion:^(BOOL finished) {
      self.currentStreamIndex = 2;
    }];
  }else if (self.currentStreamIndex == 2){
    self.currentStreamIndex = 1;
    [UIView animateWithDuration:0.1 animations:^{
      self.first_stream_view.alpha = 1;
      self.last_stream_view.alpha = 0;
    } completion:^(BOOL finished) {
      self.currentStreamIndex = 1;
    }];
  }
}
- (void)stopStream {
    [self.first_stream_view stopStreamVideo];
}

- (void)resume {
    [self.first_stream_view resume];
}
- (void)pause {
    [self.first_stream_view pause];
}
#pragma mark - set
- (void)setCurrentStreamIndex:(NSInteger)currentStreamIndex {
  _currentStreamIndex = currentStreamIndex;
}
- (void)setMachineSn:(NSString *)machineSn {
  _machineSn = machineSn;
}
#pragma mark - ZegoLivePlayerDelegate
- (void)onPlayQualityUpdate:(int)quality stream:(NSString *)streamID videoFPS:(double)fps videoBitrate:(double)kbs
{
}
#pragma mark - lazy UI
- (PPTrtcVideoView * )first_stream_view{
  if (!_first_stream_view) {
    PPTrtcVideoView * theView = [[PPTrtcVideoView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self);
      make.right.equalTo(self);
      make.top.equalTo(self);
      make.bottom.equalTo(self);
    }];
    theView.layer.masksToBounds = true;
    _first_stream_view = theView;
  }
  return _first_stream_view;
}
- (PPTrtcVideoView * )last_stream_view{
  if (!_last_stream_view) {
    PPTrtcVideoView * theView = [[PPTrtcVideoView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self);
      make.right.equalTo(self);
      make.top.equalTo(self);
      make.bottom.equalTo(self);
    }];
    theView.layer.masksToBounds = true;
    _last_stream_view = theView;
  }
  return _last_stream_view;
}
- (UIImageView * )theLeftImageView{
  if (!_theLeftImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_sain_bg_left"]];
    [self addSubview:theView];
    CGFloat margin = [self displayMarginLeftOrRight];
    if (self.pullViewForDevice == SDPullViewForSaint) {
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DSize(145));
        make.height.mas_equalTo(DSize(750));
        make.top.equalTo(self);
        make.left.equalTo(self).offset(margin - DSize(145));
      }];
    } else if (self.pullViewForDevice == SDPullViewForGoldLegend || self.pullViewForDevice == SDPullViewForPushCoin) {
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(DSize(145));
        make.left.equalTo(self);
        make.top.equalTo(self).offset(margin - DSize(145));
      }];
    }
    _theLeftImageView = theView;
  }
  return _theLeftImageView;
}
- (UIImageView * )theRightImageView{
  if (!_theRightImageView) {
    UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_sain_bg_right"]];
    [self addSubview:theView];
    CGFloat margin = [self displayMarginLeftOrRight];
    if (self.pullViewForDevice == SDPullViewForSaint) {
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DSize(145));
        make.height.mas_equalTo(DSize(750));
        make.top.equalTo(self);
        make.left.equalTo(self.mas_right).offset(-margin);
      }];
    } else if (self.pullViewForDevice == SDPullViewForGoldLegend || self.pullViewForDevice == SDPullViewForPushCoin) {
      [theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(DSize(145));
        make.left.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-margin);
      }];
    }
    _theRightImageView = theView;
  }
  return _theRightImageView;
}
@end
