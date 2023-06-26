//
//  YCJNewPlayerModel.m
//  YCJieJiGame
//
//  Created by zza on 2023/6/4.
//

#import "YCJNewPlayerModel.h"

@implementation YCJNewPlayerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"playId": @[@"id"]};
}

@end
