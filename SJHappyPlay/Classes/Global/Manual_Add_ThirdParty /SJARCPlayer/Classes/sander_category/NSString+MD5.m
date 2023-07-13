//
//  NSString+MD5.m
//  wawajiGame
//
//  Created by sander shan on 2023/3/13.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDefineHeader.h"
#import "PPSandBoxHelper.h"

@implementation NSString(MD5)

- (NSString * )getMd5 {
    const char *cStr = [self UTF8String];
    //开辟一个16字节的空间
    unsigned char result[16];
    /*
        extern unsigned char * CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
        把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了md这个空间中
    */
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ];
}

// 单个范围内设置字体大小
- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (NSMutableAttributedString *)dn_changeFont:(UIFont *)font color:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        if (font) {
            [attributedStr addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color} range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}


// 单个范围内设置字体大小
- (NSMutableAttributedString *)dn_changeColor:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    
    if ([self checkRange:range] == RangeCorrect) {
        
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        } else {
            NSLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (RangeFormatType)checkRange:(NSRange)range {
    NSInteger loc = range.location;
    NSInteger len = range.length;
    
    if (loc >= 0 && len > 0) {
        
        if (loc + len <= self.length) {
            
            return RangeCorrect;
        }else{
            NSLog(@"The range out-of-bounds!");
            return RangeOut;
        }
    }else{
        NSLog(@"The range format is wrong: NSMakeRange(a,b) (a>=0,b>0). ");
        return RangeError;
    }
}

+ (NSString *)convertImageNameWithLanguage:(NSString *)imageName {
    NSString *name = imageName;
//    if([PPSandBoxHelper getCurrentLanguage] == 3) {
//        name = [NSString stringWithFormat:@"%@_en", imageName];
//    }
    return name;
}

@end
