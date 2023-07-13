#import "PPDetailImageTableViewCell.h"
#import "PPDetailImageDataModel.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "AppDefineHeader.h"

@interface PPDetailImageTableViewCell ()
@property (nonatomic, weak) UIImageView * theImageView;
@end
@implementation PPDetailImageTableViewCell
- (PPDetailImageDataModel * )targetModel{
  return (PPDetailImageDataModel * )self.dataModel;
}
- (void)loadHomeDataModel:(PPHomeBaseDataModel *)model {
  [super loadHomeDataModel:model];
  [self.theImageView sd_setImageWithURL: [NSURL URLWithString:[self targetModel].image]];
}
#pragma mark - lazy UI
- (UIImageView * )theImageView{
  if (!_theImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView);
    }];
    _theImageView = theView;
  }
  return _theImageView;
}
@end
