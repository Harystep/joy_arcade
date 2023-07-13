#import "PPChatMessageDataModel.h"
#import "PPChatMessageTableViewCell.h"
#import "UIColor+MCUIColorsUtils.h"
#import "AppDefineHeader.h"

@implementation PPChatMessageDataModel
@synthesize chatMessage = _chatMessage;
- (NSString *)CellIdentifier
{
    return [PPChatMessageTableViewCell getCellIdentifier];
}
- (instancetype)initWithType:(SDChatMessageType)type
{
  self = [super init];
  if (self) {
    _chatType = type;
  }
  return self;
}
- (void)configChatMessage {
  NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] init];
    UIFont * messageFont = AutoPxFont(24);
  NSAttributedString * chatMessageStr = [[NSAttributedString alloc] initWithString:self.message attributes:@{NSFontAttributeName: messageFont, NSForegroundColorAttributeName: [UIColor whiteColor]}];
  switch (self.chatType) {
    case intoRoom: {
      NSAttributedString * chatNameStr = [[NSAttributedString alloc] initWithString:self.chatName attributes:@{NSFontAttributeName: messageFont, NSForegroundColorAttributeName: [UIColor colorForHex:@"#E8759B"]}];
      [attributedStr insertAttributedString:chatNameStr atIndex:0];
      [attributedStr insertAttributedString:chatMessageStr atIndex:chatNameStr.length];
      break;
    }
    case customMessage: {
      NSAttributedString * chatNameStr = [[NSAttributedString alloc] initWithString:self.chatName attributes:@{NSFontAttributeName: messageFont, NSForegroundColorAttributeName: [UIColor colorForHex:@"#F6D638"]}];
      [attributedStr insertAttributedString:chatNameStr atIndex:0];
      [attributedStr insertAttributedString:chatMessageStr atIndex:chatNameStr.length];
      break;
    }
    case systemMessage: {
      [attributedStr insertAttributedString:chatMessageStr atIndex:0];
      break;
    }
    default:
      break;
  }
  _chatMessage = [attributedStr copy];
  CGRect chatMessageFrame = [self.chatMessage boundingRectWithSize:CGSizeMake(DSize(342), MAXFLOAT) options:NSStringDrawingUsesFontLeading context:nil];
  self.hegiht_size_cell = chatMessageFrame.size.height + DSize(40);
}
@end
