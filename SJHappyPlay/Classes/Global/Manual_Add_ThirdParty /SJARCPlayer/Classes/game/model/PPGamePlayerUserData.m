#import "PPGamePlayerUserData.h"
@implementation PPGamePlayerUserData
- (instancetype)initWithUsername:(NSString * )userName avatarUrl: (NSString * )avatarUrl
{
  self = [super init];
  if (self) {
    _userName = userName;
    _avatarUrl = avatarUrl;
  }
  return self;
}
@end
