

#import "QAExchangeModel.h"

@implementation QAExchangeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"exchangeId": @[@"id"]};
}

@end
