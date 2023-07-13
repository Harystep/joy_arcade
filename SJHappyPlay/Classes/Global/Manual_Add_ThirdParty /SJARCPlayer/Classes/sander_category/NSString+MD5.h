//
//  NSString+MD5.h
//  wawajiGame
//
//  Created by sander shan on 2023/3/13.
//

#import <Foundation/Foundation.h>

/**
 * @brief range的校验结果
 */
typedef enum
{
    RangeCorrect = 0,
    RangeError = 1,
    RangeOut = 2,
    
}RangeFormatType;

NS_ASSUME_NONNULL_BEGIN

@interface NSString(MD5)

- (NSString * )getMd5;

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font andRange:(NSRange)range;

- (NSMutableAttributedString *)dn_changeColor:(UIColor *)color andRange:(NSRange)range;

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font color:(UIColor *)color andRange:(NSRange)range;

+ (NSString *)convertImageNameWithLanguage:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
