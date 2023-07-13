#import "PPHomeBaseDataModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
  intoRoom,
  customMessage,
  systemMessage,
} SDChatMessageType;
@interface PPChatMessageDataModel : PPHomeBaseDataModel
@property (nonatomic, strong) NSString * chatName;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) SDChatMessageType chatType;
@property (nonatomic, strong, readonly) NSAttributedString * chatMessage;
- (void)configChatMessage;
@end
NS_ASSUME_NONNULL_END
