#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@class PPChatMessageDataModel;
@interface PPChatMessageView : UIView
- (void)insertChatMessage:(PPChatMessageDataModel * )chatModel;
@property (nonatomic, assign) BOOL inputChatHidden;
@property (nonatomic, strong) RACSubject * inputChatSubject;
@end
NS_ASSUME_NONNULL_END
