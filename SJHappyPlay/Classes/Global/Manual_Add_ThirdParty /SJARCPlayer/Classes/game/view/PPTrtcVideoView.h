#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WsRTC/WsRTCLive.h>


NS_ASSUME_NONNULL_BEGIN
@interface PPTrtcVideoView : UIView
@property (nonatomic, weak) WsRTCLiveView * vidoeView;
@property (nonatomic, strong) NSString * streamUrl;
- (void)loadDefineVideoImageUrl:(NSString * )imageUrl;
- (void)loadFullVideoImageUrl:(NSString * )imageUrl;
- (void)startStreamUrl:(NSString *)streamUrl;
- (void)startStreamUrlWithFFmpegAudio:(NSString *)streamUrl;
- (void)stopStreamVideo;
- (void)resume;
- (void)pause;
@end
NS_ASSUME_NONNULL_END
