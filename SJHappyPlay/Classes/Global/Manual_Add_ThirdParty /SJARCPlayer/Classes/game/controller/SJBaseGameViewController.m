#import "SJBaseGameViewController.h"
#import "MBProgressHUD.h"
#import "PPNetworkConfig.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "PPUserInfoService.h"
#import "UIView+Toast.h"
#import "SDAlertShowManager.h"
#import "AppDefineHeader.h"

@interface SJBaseGameViewController ()<SDGameViewModelDelegate, SDHubProtocol>
@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, strong) AVAudioPlayer     *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer     *audioEffect;
@end
@implementation SJBaseGameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
        self.iPhoneXFlag = YES;
    } else {
        self.iPhoneXFlag = NO;
    }
    [PPNetworkConfig sharedInstance].hubDelegate = self;
    NSString * access_token = [PPUserInfoService get_Instance].access_token;
    if (access_token && [access_token length] > 0) {
        self.viewModel = [[SJGameViewModel alloc] initWithMachineSn:self.machineSn roomId:self.room_id];
        self.viewModel.delegate = self;
    } else {
        if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
            self.viewModel = [[SJGameViewModel alloc] initWithMachineSn:self.machineSn roomId:self.room_id];
            self.viewModel.delegate = self;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)enterNewRoom:(NSString *)machineSn room_id:(NSString *)roomId {
    self.machineSn = machineSn;
    self.room_id = roomId;
    NSString * access_token = [PPUserInfoService get_Instance].access_token;
    if (access_token && [access_token length] > 0) {
        self.viewModel = [[SJGameViewModel alloc] initWithMachineSn:self.machineSn roomId:self.room_id];
        self.viewModel.delegate = self;
    } else {
        if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
            self.viewModel = [[SJGameViewModel alloc] initWithMachineSn:self.machineSn roomId:self.room_id];
            self.viewModel.delegate = self;
        }
    }
//    if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
//    } else {
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pullVideoView loginRoomId:self.machineSn];
    });
}

- (BOOL)shouldAutorotate {
    return false;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled: true];
    NSString * access_token = [PPUserInfoService get_Instance].access_token;
    if (access_token && [access_token length] > 0) {
    } else {
        if (![[PPNetworkConfig sharedInstance] inAppStoreReview]) {
        } else {
            [self.pullVideoView loginRoomId:self.machineSn];
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - public method
- (void)dismissGame{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)dismissGameByNotAccountToken {
    [self dismissGame];
    NSDictionary * info = @{@"errCode": @(401)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login_status_error" object:info];
}
#pragma mark - 播放音乐
- (void)start_play_bg_music
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:backgroudmusic])
    {
        if (self.audioPlayer && self.audioPlayer.isPlaying){
            return;
        }
        if (self.canPlayMusic) {
            NSURL *url=[[NSBundle mainBundle] URLForResource:@"background.mp3" withExtension:Nil subdirectory:@"SJARCPlayer.bundle"];
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            self.audioPlayer.numberOfLoops = -1;
        }
    }
}
#pragma mark - 停止播放背景音乐
- (void)stop_play_bg_music
{
    if (self.audioPlayer){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        [self.audioPlayer pause];
    }
}
#pragma mark - 播放 开始游戏的音效
- (void)play_start_effect
{
    [self playEffect:@"sound_button.mp3"];
}
- (void)playCoinEffect {
    [self playEffect:@"get_coin.mp3"];
}
- (void)playPushCoinEffect {
    [self playnoteffect:@"push_coin_bt.mp3"];
}
#pragma mark - 播放 effect
- (void)playEffect:(NSString *)str
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:backgroudmusic])
    {
        if(self.audioEffect)
        {
            [self.audioEffect stop];
            self.audioEffect = nil;
        }
        NSURL *url=[[NSBundle mainBundle] URLForResource:str withExtension:Nil subdirectory:@"SJARCPlayer.bundle"];
        self.audioEffect = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        [self.audioEffect prepareToPlay];
        [self.audioEffect play];
    }
}
- (void)playnoteffect:(NSString *)str {
    if([[NSUserDefaults standardUserDefaults] boolForKey:backgroudmusic])
    {
        NSURL *url=[[NSBundle mainBundle] URLForResource:str withExtension:Nil subdirectory:@"SJARCPlayer.bundle"];
        self.audioEffect = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        [self.audioEffect prepareToPlay];
        [self.audioEffect play];
    }
}

- (void)applicationBecomeActive {
    NSLog(@"[app] ----> applicationBecomeActive");
    [self.pullVideoView resume];
}

- (void)applicationDidEnterBackground {
    NSLog(@"[app] ----> applicationDidEnterBackground");
    [self.pullVideoView pause];
    
}
#pragma mark - SDGameViewModelDelegate
- (void)loginGamePullStearm:(NSString *)roomId {
    [self.pullVideoView loginRoomId:roomId];
}
- (void)showErrorToastMessage:(NSString *)message {
    [self.view makeToast: message];
}
- (void)showLoading {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
    });
}
- (void)dealloc {
    NSLog(@"[viewController] -----> dealloc");
    [self.viewModel leaveRoom];
    [self.pullVideoView leaveRoom];
}
- (void)showMaintainErrorView {
    @weakify_self;
    [SDAlertShowManager showSystemSureAlertinViewController:self Title:@"通知" Message:@"设备维修中，请切换到其他房间" handler:^(UIAlertAction *action) {
        @strongify_self;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark - SDHubProtocol
- (void)showHub:(NSString *)message {
    NSLog(@"[showLoading] ---- ");
    [self showLoading];
}
- (void)dissmissHub {
    NSLog(@"[dissmissHub] ---- ");
    [self hideLoading];
}
@end
