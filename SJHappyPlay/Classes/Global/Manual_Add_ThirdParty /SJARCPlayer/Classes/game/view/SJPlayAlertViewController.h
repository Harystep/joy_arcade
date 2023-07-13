#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
  SDAlertShowSendMessage,
  SDAlertShowAppmentPlay,
} SDAlertShowType;
typedef void(^SDInputChatBlock)(NSString * inputChatStr);
typedef void(^SDGameAlertBlock)(int type);
@interface SJPlayAlertViewController : UIViewController
@property (nonatomic, assign) SDAlertShowType alertShowType;
@property (nonatomic, copy) SDInputChatBlock inputChatBlock;
@property (nonatomic, copy) SDGameAlertBlock alertBlock;
@property (nonatomic, assign) NSInteger waitSeconds;
@end
NS_ASSUME_NONNULL_END
