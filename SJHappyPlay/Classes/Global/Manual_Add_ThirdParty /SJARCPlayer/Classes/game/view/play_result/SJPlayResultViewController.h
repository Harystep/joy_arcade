#import <UIKit/UIKit.h>
typedef void(^PlayResultBlock)(NSInteger actionType);
@interface SJPlayResultViewController : UIViewController
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger protection_seconds;
@property (nonatomic, assign) NSString *   name;
@property (nonatomic, strong)NSString *  game_win_image_url;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSString *  level;
@property (nonatomic, assign) NSInteger ballNum;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isOtherPlay;
@property (nonatomic, copy) PlayResultBlock playResultAction;
@end
