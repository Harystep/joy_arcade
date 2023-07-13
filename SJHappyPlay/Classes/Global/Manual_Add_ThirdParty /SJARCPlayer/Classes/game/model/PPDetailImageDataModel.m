#import "PPDetailImageDataModel.h"
#import "AppDefineHeader.h"
#import "SDWebImageDownloader.h"
#import "AppDefineHeader.h"
@implementation PPDetailImageDataModel
- (NSString * )CellIdentifier {
  return @"PPDetailImageTableViewCell";
}
- (instancetype)initWithImg:(NSString * )img
{
  self = [super init];
  if (self) {
    _image = img;
    self.hegiht_size_cell = SF_Float(750);
    [self configData];
  }
  return self;
}
- (void)configData {
  self.updateSubject = [RACSubject subject];
  [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.image] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
    CGSize imageSize = image.size;
    CGFloat cell_height = SCREEN_WIDTH / imageSize.width * imageSize.height;
    if (cell_height > 0) {
      self.hegiht_size_cell = SCREEN_WIDTH / imageSize.width * imageSize.height;
    }
    [self.updateSubject sendNext:@(self.row)];
  }];
}
@end
