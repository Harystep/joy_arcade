//
//  JKSingleton.h
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//


#define JKSingletonH(methodName) + (instancetype)share##methodName;

#define JKSingletonM(methodName) \
static id _instance = nil;\
+ (instancetype)share##methodName {\
    return [[self alloc] init];\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
\
- (instancetype)init {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super init];\
    });\
    return _instance;\
}
