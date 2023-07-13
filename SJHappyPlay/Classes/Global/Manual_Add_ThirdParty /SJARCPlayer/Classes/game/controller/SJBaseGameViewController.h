#import <UIKit/UIKit.h>
#import "SJGameViewModel.h"
#import "SJPullVideoView.h"

typedef enum : NSUInteger {
    SDGame_define,
    SDGame_selfPlaying, 
    SDGame_otherPlaying, 
    SDGame_pk_selfPlaying, 
    SDGame_pk_otherPlaying, 
    SDGame_pk_otherLook, 
} SDGamePlayStatues;
typedef enum : NSUInteger {
    SDPlayGameControl_TouchDown_UP = 1,
    SDPlayGameControl_TouchDown_DOWN = 2,
    SDPlayGameControl_TouchDown_LEFT = 3,
    SDPlayGameControl_TouchDown_RIGHT = 4,
    SDPlayGameControl_TouchUp_UP = 5,
    SDPlayGameControl_TouchUp_DOWN = 6,
    SDPlayGameControl_TouchUp_LEFT = 7,
    SDPlayGameControl_TouchUp_RIGHT = 8,
    SDPlayGameControl_CATCH
} SDPlayGameControlType;
typedef enum : NSUInteger {
  SDSaintLastPress_PushCoin, 
  SDSaintLastPress_Settlement, 
  SDSaintLastPress_Move, 
  SDSaintLastPress_Operate, 
  SDSaintLastPress_Fire, 
  SDSaintLastPress_Fire_Double, 
  SDSaintLastPress_Close, 
  SDSaintLastPress_AFK, 
} SDSaintLastPress;
NS_ASSUME_NONNULL_BEGIN
@interface SJBaseGameViewController : UIViewController
@property (nonatomic, strong) NSString * machineSn;
@property (nonatomic, strong) NSString * room_id;
@property (nonatomic, weak) SJPullVideoView * pullVideoView;
@property (nonatomic, assign) SDGamePlayStatues playStatus;
@property(nonatomic, strong) SJGameViewModel * viewModel;
@property (nonatomic, assign) BOOL canPlayMusic;
@property (nonatomic,assign) BOOL iPhoneXFlag;
- (void)dismissGameByNotAccountToken;
- (void)dismissGame;
- (void)showLoading;
- (void)hideLoading;
- (void)start_play_bg_music;
- (void)stop_play_bg_music;
- (void)play_start_effect;
- (void)playEffect:(NSString *)str;
- (void)playCoinEffect;
- (void)playPushCoinEffect;

- (void)enterNewRoom:(NSString *)machineSn room_id:(NSString *)roomId;

@end
NS_ASSUME_NONNULL_END
