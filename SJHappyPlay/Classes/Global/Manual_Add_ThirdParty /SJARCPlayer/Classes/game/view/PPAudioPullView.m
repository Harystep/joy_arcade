#import "PPAudioPullView.h"

//#import <IJKMediaFramework/IJKMediaFramework.h>


@interface PPAudioPullView ()
//@property(atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, strong) NSURL * playUrl;
@end
@implementation PPAudioPullView
- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}
- (instancetype)initWithUrl:(NSString *)url
{
  self = [super init];
  if (self) {
    self.playUrl = [NSURL URLWithString:url];
    self.frame = CGRectMake(0, 0, 1, 1);
    [self configAudio];
  }
  return self;
}
- (void)configAudio {
//  IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//  [options setOptionIntValue:500 forKey:@"analyzemaxduration" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:1024 * 16 forKey:@"probesize" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:1 forKey:@"flush_packets" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:0 forKey:@"http-detect-range-support" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionValue:@"tcp" forKey:@"rtsp_transport" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:1 forKey:@"rtmp_buffer" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:1000 forKey:@"rtmp_buffer_size" ofCategory:kIJKFFOptionCategoryFormat];
//  [options setOptionIntValue:1 forKey:@"enable-accurate-seek" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setOptionIntValue:1 forKey:@"framedrop" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setOptionIntValue:1 forKey:@"mediacodec-hevc" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setOptionIntValue:0 forKey:@"mediacodec" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setOptionIntValue:1 forKey:@"fast" ofCategory:kIJKFFOptionCategoryPlayer];
//  [options setCodecOptionIntValue:0 forKey:@"skip_loop_filter"];
//  [options setCodecOptionIntValue:1 forKey:@"skip_frame"];
//  [options setPlayerOptionIntValue:10 forKey:@"max_cached_duration"];
//  [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
//  [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
//  self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.playUrl withOptions:options];
//  self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//  self.player.view.frame = self.bounds;
//  self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//  self.player.shouldAutoplay = YES;
//  [self addSubview:self.player.view];
//  [self.player prepareToPlay];
}
- (void)shutdown {
//  [self.player shutdown];
}
@end
