//
//  JKNetWorkResult.m
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import "JKNetWorkResult.h"

#import "YCJLoginViewController.h"

@implementation JKNetWorkResult

+ (instancetype)resultWithError:(NSError *)error {
    [MBProgressHUD hideHUD];
    JKNetWorkResult *result = [[JKNetWorkResult alloc] init];
    NSString *errorMsg = kCommonError;
    result.error = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    return result;
}

+ (instancetype)resultWithResultObject:(id)resultObject {
    NSString *errorDefault = kCommonError;
    if(!resultObject || ![resultObject isKindOfClass:[NSDictionary class]]) {
        NSError *error =  [NSError errorWithDomain:errorDefault code:10000 userInfo:@{NSLocalizedDescriptionKey: errorDefault}];
        return [self resultWithError:error];
    }
    [MBProgressHUD hideHUD];
    NSInteger code = [[resultObject objectForKey:@"errCode"] integerValue];
    NSString *msg = [resultObject objectForKey:@"errMsg"] ? : errorDefault;
    NSString *data = [resultObject objectForKey:@"data"];
    if(code == 0) {
        JKNetWorkResult *result = [[JKNetWorkResult alloc] init];
        result.resultObject = (NSDictionary *)resultObject;
        result.resultData = data;
        NSLog(@"result.resultData = %@",result.resultData);
        return result;
    }else {
        if(code == 401) {
           UIWindow *window = [UIApplication sharedApplication].keyWindow;
           [[YCJUserInfoManager sharedInstance] deleteUserInfo];
           [window.rootViewController presentViewController:[YCJLoginViewController new] animated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuckey object:nil];
        }
        NSError *error = [NSError errorWithDomain:msg code:code userInfo:@{NSLocalizedDescriptionKey: msg}];
        JKNetWorkResult *result = [[JKNetWorkResult alloc] init];
        result.error = error;
        return result;
    }
}

- (NSInteger)total {
    NSDictionary *dict = self.resultData;
    if([dict isKindOfClass:[NSDictionary class]]) {
        NSString *total = dict[@"total"];
        if([total isKindOfClass:[NSString class]] || [total isKindOfClass:[NSNumber class]]) {
            return [total integerValue];
        }
    }
    return 0;
}

@end
