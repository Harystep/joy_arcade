#import "PPSandBoxHelper.h"

#define ARC_EN_LAN(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"EN" ofType:@"lproj" inDirectory:nil]] localizedStringForKey:key value:@""table:nil]

#define ARC_ZH_LAN(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh_Hans" ofType:@"lproj" inDirectory:nil]] localizedStringForKey:key value:@""table:nil]

#define ARC_ZH_HANT(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh_Hant" ofType:@"lproj" inDirectory:nil]] localizedStringForKey:key value:@""table:nil]

@implementation PPSandBoxHelper
+ (NSString *)homePath {
    return NSHomeDirectory();
}
+ (NSString *)aSJPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
+ (NSString *)docPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
+ (NSString *)libPrefPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}
+ (NSString *)libCachePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}
+ (NSString *)tmpPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}
+ (NSString *)iapReceiptPath {
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/EACEF35FE363A75A"];
    [self hasLive:path];
    return path;
}
+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}
+(NSString *)SuccessIapPath{
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/SuccessReceiptPath"];
    [self hasLive:path];
    return path;
}
+(NSString *)exitResourePath{
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/ExitResourePath"];
    [self hasLive:path];
    return path;
}
+(NSString *)tempOrderPath{
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/tempOrderPath"];
    [self hasLive:path];
    return path;
}
+(NSString *)crashLogInfo{
    NSString * path = [[self libPrefPath]stringByAppendingFormat:@"/crashLogInfoPath"];
    [self hasLive:path];
    return path;
}

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

+ (NSString *)arc_convertLanguageContent:(NSString *)content {
    NSString *local = @"";
    NSInteger type = [self getCurrentLanguage];
    switch (type) {
        case 1:
            local = ARC_ZH_LAN(content);
            break;
        case 2:
            local = ARC_ZH_HANT(content);
            break;
        case 3:
            local = ARC_EN_LAN(content);
            break;
            
        default:
            break;
    }
    return local;
}

+ (NSInteger)preSetLanguageType {
    NSInteger type = 3;
//    NSString *local = [[NSLocale preferredLanguages] objectAtIndex:0];
//    if([local containsString:@"zh-Hans"]) {
//        type = 1;
//    } else if ([local containsString:@"zh-Hant"]) {
//        type = 2;
//    } else if ([local containsString:@"en"]) {
//        type = 3;
//    }
    return type;
}

+ (NSInteger)getUserLanguageType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"kSetUserLanguageKey"];
}

@end
