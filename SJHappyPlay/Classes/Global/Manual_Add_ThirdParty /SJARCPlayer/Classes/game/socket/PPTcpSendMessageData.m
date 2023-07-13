#import "PPTcpSendMessageData.h"
@implementation PPTcpSendMessageData
- (instancetype)initWithVmc_no:(NSString *)vmc_no content:(NSString * )content
{
    self = [super initWithVmc_no:vmc_no cmd:@"text_message"];
    if (self) {
        self.content = content;
    }
    return self;
}
@end
