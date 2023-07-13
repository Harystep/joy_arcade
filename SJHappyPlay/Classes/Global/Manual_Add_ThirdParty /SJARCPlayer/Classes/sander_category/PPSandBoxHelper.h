#import <Foundation/Foundation.h>
@interface PPSandBoxHelper : NSObject
+ (NSString *)homePath;             
+ (NSString *)aSJPath;              
+ (NSString *)docPath;              
+ (NSString *)libPrefPath;          
+ (NSString *)libCachePath;         
+ (NSString *)tmpPath;              
+ (NSString *)iapReceiptPath;       
+(NSString *)SuccessIapPath;        
+(NSString *)crashLogInfo;          
+(NSString *)exitResourePath;   
+(NSString *)tempOrderPath;

+ (NSInteger)getCurrentLanguage;
+ (NSString *)arc_convertLanguageContent:(NSString *)content;

@end
