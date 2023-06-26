//
//  JKNetWorkClient.m
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import "JKNetWorkClient.h"

@implementation JKNetWorkClient

+ (instancetype)shareClient {
    static JKNetWorkClient* client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] init];
        client.requestSerializer = [AFJSONRequestSerializer serializer];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
//        解决后端通过request.getParameters()获取不到参数问题
        client.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];

        client.requestSerializer.timeoutInterval = 5;
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        client.securityPolicy = securityPolicy;
        client.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
        [client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        client.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        client.baseUrlString = [JKTools getBaseUrl];
        
    });
    return client;
}


@end
