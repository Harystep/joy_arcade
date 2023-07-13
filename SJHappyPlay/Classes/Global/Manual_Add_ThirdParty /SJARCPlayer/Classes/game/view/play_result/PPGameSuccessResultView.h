#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface PPGameSuccessResultView : UIView
@property (nonatomic, strong)NSString *  game_win_image_url;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger ballNum;
@property (nonatomic, assign) NSInteger type;
- (void)displayView;
- (void)displayOtherPlay;
@end
NS_ASSUME_NONNULL_END
