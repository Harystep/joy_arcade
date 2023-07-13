#import "SJPlayerAvatarView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "AppDefineHeader.h"

@interface SJPlayerAvatarView ()
@property (nonatomic, weak) UIImageView * theImageView;
@end
@implementation SJPlayerAvatarView
- (instancetype)initWithSize:(CGFloat)size
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, size, size);
    [self configView];
  }
  return self;
}
- (void)configView {
  self.layer.cornerRadius = self.bounds.size.width / 2.0;
  self.layer.masksToBounds = true;
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.layer.borderWidth = DSize(4);
}
- (void)setAvatarUrl:(NSString *)avatarUrl {
  _avatarUrl = avatarUrl;
  [self.theImageView sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl]];
}
#pragma mark - lazy UI
- (UIImageView * )theImageView{
  if (!_theImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - DSize(8), self.bounds.size.width - DSize(8)));
    }];
    _theImageView = theView;
  }
  return _theImageView;
}
@end
