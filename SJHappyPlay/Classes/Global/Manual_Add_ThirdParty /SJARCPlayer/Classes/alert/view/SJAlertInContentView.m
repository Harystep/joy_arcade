#import "SJAlertInContentView.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"

#import "AppDefineHeader.h"

@implementation SJAlertInContentView
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self configView];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  self.backgroundColor = [UIColor whiteColor];
  self.layer.masksToBounds = true;
  self.layer.cornerRadius = SF_Float(10);
  [self createPointView:0];
  [self createPointView:1];
  [self createPointView:2];
  [self createPointView:3];
}
- (void)createPointView:(NSInteger)tag {
  UIView * theView = [[UIView alloc] init];
  theView.layer.cornerRadius = SF_Float(7);
  theView.backgroundColor = [UIColor colorForHex:@"#F8F09B"];
  [self addSubview:theView];
  [theView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(SF_Float(14));
    make.height.mas_equalTo(SF_Float(14));
    if (tag == 0) {
      make.left.equalTo(self).offset(SF_Float(10));
      make.top.equalTo(self).offset(SF_Float(10));
    } else if (tag == 1) {
      make.right.equalTo(self.mas_right).offset(SF_Float(-10));
      make.top.equalTo(self).offset(SF_Float(10));
    } else if (tag == 2) {
      make.left.equalTo(self).offset(SF_Float(10));
      make.bottom.equalTo(self.mas_bottom).offset(SF_Float(-10));
    } else if (tag == 3) {
      make.bottom.equalTo(self.mas_bottom).offset(SF_Float(-10));
      make.right.equalTo(self.mas_right).offset(SF_Float(-10));
    }
  }];
}
@end
