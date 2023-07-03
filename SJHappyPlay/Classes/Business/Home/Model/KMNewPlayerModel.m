

#import "KMNewPlayerModel.h"

@implementation KMNewPlayerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"playId": @[@"id"]};
}

@end
