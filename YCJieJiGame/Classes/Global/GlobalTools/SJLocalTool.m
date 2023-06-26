//
//  SJLocalTool.m
//  YCJieJiGame
//
//  Created by oneStep on 2023/6/25.
//

#import "SJLocalTool.h"

#define EN_LAN(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en"ofType:@"lproj"]] localizedStringForKey:key value:@""table:nil]

#define ZH_LAN(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh-Hans"ofType:@"lproj"]] localizedStringForKey:key value:@""table:nil]

#define ZH_HANT(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh-Hant"ofType:@"lproj"]] localizedStringForKey:key value:@""table:nil]

@implementation SJLocalTool

+ (NSInteger)getCurrentLanguage {
    NSInteger type = 0;
    NSInteger currentType = [self getUserLanguageType];
    if(currentType > 0) {
        type = currentType;
    } else {
        type = [self preSetLanguageType];
//        [self saveUserLanguageType:type];
    }
    return type;
}

+ (NSString *)convertLanguageContent:(NSString *)content {
    NSString *local = @"";
    NSInteger type = [self getCurrentLanguage];
    switch (type) {
        case 1:
            local = ZH_LAN(content);
            break;
        case 2:
            local = ZH_HANT(content);
            break;
        case 3:
            local = EN_LAN(content);
            break;
            
        default:
            break;
    }
    return local;
}

+ (NSInteger)preSetLanguageType {
    NSInteger type = 0;
    NSString *local = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"local:%@", local);
    if([local containsString:@"zh-Hans"]) {
        type = 1;
    } else if ([local containsString:@"zh-Hant"]) {
        type = 2;
    } else if ([local containsString:@"en"]) {
        type = 3;
    }
    return type;
}

+ (void)saveUserLanguageType:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"kSetUserLanguageKey"];
}

+ (NSInteger)getUserLanguageType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"kSetUserLanguageKey"];
}

@end
