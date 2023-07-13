#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface PPImageUtil : NSObject
+ (UIImage *)getImage:(NSString *)imageName;
+ (UIImage *)imageNamed:(NSString *) imageName;
+ (UIImage *) getImageFromURL:(NSString *)fileURL;
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
@end
NS_ASSUME_NONNULL_END
