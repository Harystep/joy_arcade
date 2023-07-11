

#import <Foundation/Foundation.h>
#import "YCPhotoBrowserConst.h"

@interface YCPhotoBrowserCellHelper : NSObject

+ (instancetype)helperWithPhotoSourceType:(YCPhotoSourceType )sourceType imagesOrURL:(id)imagesOrURL  urlReplacing:(NSDictionary *)parameter;

- (NSURL *)downloadURL;
- (UIImage *)localImage;
- (UIImage *)placeholderImage;
- (void)setPlaceholderImage:(UIImage *)image;
- (BOOL)isLoaclImage;
@end
