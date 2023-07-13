#import "SJPlayActionButton.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
@interface SJPlayActionButton()
@property (nonatomic, weak) UIImageView * theShowView;
@property (nonatomic, strong) AVAudioPlayer     *audioEffect;
@end
@implementation SJPlayActionButton
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)setNomal_image:(UIImage *)nomal_image
{
    _nomal_image = nomal_image;
    self.theShowView.image = nomal_image;
}
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (self.enabled == false) {
        self.theShowView.image = self.disable_image;
    }else{
        self.theShowView.image = self.nomal_image;
    }
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (self.selected) {
        self.theShowView.image = self.selected_image;
    }else{
        self.theShowView.image = self.nomal_image;
    }
}
- (void)action_begain:(UIEvent *)event
{
    for (id target in [self allTargets]) {
        NSArray * actions = [self actionsForTarget:target forControlEvent:UIControlEventTouchDown];
        for (NSString * action in actions) {
            [self sendAction:NSSelectorFromString(action) to:target forEvent:event];
        }
    }
}
- (void)action_end:(UIEvent *)event
{
    for (id target in [self allTargets]) {
        NSArray * actions = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString * action in actions) {
            [self sendAction:NSSelectorFromString(action) to:target forEvent:event];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = true;
    [self action_begain:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = false;
    [self playEffect:@"sound_button.mp3"];
    [self action_end:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = false;
    [self playEffect:@"sound_button.mp3"];
    [self action_end:event];
}
- (void)playEffect:(NSString *)str
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"set_switch2"])
    {
        if(self.audioEffect)
        {
            [self.audioEffect stop];
            self.audioEffect = nil;
        }
        NSURL *url=[[NSBundle mainBundle] URLForResource:str withExtension:Nil];
        self.audioEffect = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        [self.audioEffect prepareToPlay];
        [self.audioEffect play];
        self.audioEffect.numberOfLoops = 1;
    }
}
- (UIImageView *)theShowView
{
    if (!_theShowView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _theShowView = theView;
    }
    return _theShowView;
}
@end
