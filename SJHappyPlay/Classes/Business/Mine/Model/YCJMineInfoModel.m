

#import "YCJMineInfoModel.h"

@implementation YCJMineInfoModel

+ (instancetype)modelWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr {
    return [[self alloc] initWithLeftIcon:leftIcon leftStr:leftStr rightStr:rightStr destinationClass:nil];
}

+ (instancetype)modelWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass {
    return [[self alloc] initWithLeftIcon:leftIcon leftStr:leftStr rightStr:rightStr destinationClass:destinationClass];
}

+ (instancetype)modelWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass {
    return [self modelWithLeftIcon:@"" leftStr:leftStr rightStr:rightStr destinationClass:destinationClass];
}

- (instancetype)initWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass {
    if (self = [super init]) {
        self.leftIcon = leftIcon;
        self.leftStr = leftStr;
        self.rightStr = rightStr;
        self.destinationClass = destinationClass;
    }
    return self;
}

- (instancetype)initWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass {
    return [self initWithLeftIcon:@"" leftStr:leftStr rightStr:rightStr destinationClass:destinationClass];
}


@end
