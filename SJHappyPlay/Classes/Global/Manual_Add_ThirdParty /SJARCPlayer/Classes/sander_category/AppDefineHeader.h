#ifndef AppDefineHeader_h
#define AppDefineHeader_h
#import "UIFont+SDFont.h"
#import "SJLocalTool.h"

#define ZCLocal(key) [SJLocalTool convertLanguageContent:key]

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEH_HEIGHT [UIScreen mainScreen].bounds.size.height
// 刘海屏适配判断
#define iPhone_X (UIApplication.sharedApplication.statusBarFrame.size.height > 20.0)

// 状态栏高度
#define STATUS_H          UIApplication.sharedApplication.statusBarFrame.size.height
#define STATUS_BAR_HEIGHT (iPhone_X ? 44.f : 20.f)

#define DFont(float) float * 1.15 / 3.f

#define DSize(float) ((float) / 2.f * (SCREEN_WIDTH < SCREEH_HEIGHT ? SCREEN_WIDTH : SCREEH_HEIGHT) / 375.f)

#define SF_Float(float) ((float) / 2.f * (SCREEN_WIDTH < SCREEH_HEIGHT ? SCREEN_WIDTH : SCREEH_HEIGHT) / 375.f)

#define AutoPxFont(f) [UIFont autoFontWithPX:f]
#define AutoBoldPxFont(f) [UIFont autoBoldFontWithPX:f]
#define AutoMediumPxFont(f) [UIFont autoMediumFontWithPX:f]

#ifdef DEBUG 
#define SFString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DLog(...) printf("%s: %p (line = %d): %s\n\n", [SFString UTF8String] , &self, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else 
#define DLog(s, ...)
#endif
#ifndef  weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef  strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif
#endif 
