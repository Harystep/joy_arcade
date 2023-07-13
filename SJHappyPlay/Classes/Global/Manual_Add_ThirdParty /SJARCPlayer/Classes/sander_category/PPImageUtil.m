#import "PPImageUtil.h"
@implementation PPImageUtil
+ (UIImage *)getImage:(NSString *)imageName {
    NSBundle * currentBundle = [NSBundle mainBundle];
//    NSString * path = [currentBundle pathForResource:imageName ofType:@"png" inDirectory: @"SJARCPlayer.bundle"];
    NSString * path = [currentBundle pathForResource:imageName ofType:@"png" inDirectory:nil];
    return [UIImage imageWithContentsOfFile:path];
}
+ (UIImage *)imageNamed:(NSString *) imageName {
    return [self getImage:imageName];
}
+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); 
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    if (data.length > maxLength) {
        return [self compressImage:resultImage toByte:maxLength];
    }
    return data;
}
@end
