#import "PPCloseButton.h"
#import "Masonry.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPCloseButton ()
@property (nonatomic, weak) UIImageView * theCloseImageView;
@end
@implementation PPCloseButton
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, SF_Float(100), SF_Float(100));
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self theCloseImageView];
}

#pragma mark - public Method
- (void)setCloseImage:(UIImage *)closeImage {
    _closeImage = closeImage;
    self.theCloseImageView.image = closeImage;
    [self.theCloseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(SF_Float(24));
    }];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SF_Float(72), SF_Float(72)));
    }];
}
#pragma mark - lazy UI
- (UIImageView * )theCloseImageView{
  if (!_theCloseImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
      make.width.and.height.mas_equalTo(35);
    }];
      theView.image = [PPImageUtil getImage:@"img_dbj_exit_a"];
    _theCloseImageView = theView;
  }
  return _theCloseImageView;
}
@end
