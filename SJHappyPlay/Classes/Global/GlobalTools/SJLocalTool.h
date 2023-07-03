

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJLocalTool : NSObject

+ (void)saveUserLanguageType:(NSInteger)type;

+ (NSInteger)getUserLanguageType;

+ (NSString *)convertLanguageContent:(NSString *)content;

+ (NSInteger)getCurrentLanguage;

@end

NS_ASSUME_NONNULL_END
