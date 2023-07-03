

#import "JKNetWorkManager.h"
#import "JKNetWorkClient.h"
#import "JKNetWorkResult.h"

@implementation JKNetWorkManager

+ (NSURLSessionDataTask *)postRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished {
    JKNetWorkClient *client = [JKNetWorkClient shareClient];
    NSString *urlStr = urlPath;
    if(![urlPath containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", client.baseUrlString, urlPath];
        NSLog(@"urlStr = %@",urlStr);
    }
    NSDictionary *header = [self setHeadersWithUrlpath:urlPath parameters:parameters client:client];
    return [client POST:urlStr parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(finished)finished([JKNetWorkResult resultWithResultObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(finished)finished([JKNetWorkResult resultWithError:error]);
    }];
}

+ (NSURLSessionDataTask *)getRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished {
    JKNetWorkClient *client = [JKNetWorkClient shareClient];
    NSString *urlStr = urlPath;
    if(![urlPath containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", client.baseUrlString, urlPath];
        NSLog(@"urlStr = %@",urlStr);
    }
    NSDictionary *header = [self setHeadersWithUrlpath:urlPath parameters:parameters client:client];
    return [client GET:urlStr parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(finished)finished([JKNetWorkResult resultWithResultObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(finished)finished([JKNetWorkResult resultWithError:error]);
    }];
}


+ (NSURLSessionDataTask *)putRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished{
    JKNetWorkClient *client = [JKNetWorkClient shareClient];
    NSString *urlStr = urlPath;
    if(![urlPath containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", client.baseUrlString, urlPath];
        NSLog(@"urlStr = %@",urlStr);
    }
    NSDictionary *header = [self setHeadersWithUrlpath:urlPath parameters:parameters client:client];
    return  [client PUT:urlStr parameters:parameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(finished)finished([JKNetWorkResult resultWithResultObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(finished)finished([JKNetWorkResult resultWithError:error]);
    }];
    
}


+ (NSURLSessionDataTask *)deleteRequestWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters finished:(resultInfoBlock)finished{
    JKNetWorkClient *client = [JKNetWorkClient shareClient];
    NSString *urlStr = urlPath;
    if(![urlPath containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", client.baseUrlString, urlPath];
        NSLog(@"urlStr = %@",urlStr);
    }
    NSDictionary *header = [self setHeadersWithUrlpath:urlPath parameters:parameters client:client];
    return  [client DELETE:urlStr parameters:parameters headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(finished)finished([JKNetWorkResult resultWithResultObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(finished)finished([JKNetWorkResult resultWithError:error]);
    }];
}


+ (NSURLSessionDataTask *)uploadImageWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters image:(UIImage *)image finished:(resultInfoBlock)finished {
    JKNetWorkClient *client = [JKNetWorkClient shareClient];
    client.requestSerializer.timeoutInterval = 60;
    NSString *urlStr = urlPath;
    if(![urlPath containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", client.baseUrlString, urlPath];
        NSLog(@"urlStr = %@",urlStr);
    }
    NSDictionary *header = [self setHeadersWithUrlpath:urlPath parameters:parameters client:client];
    return [client POST:urlStr parameters:parameters headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        if(imgData.length > 2 * 1024 * 1024) {
            imgData = UIImageJPEGRepresentation(image, 0.15);
        }
        NSString *imgName = [parameters objectForKey:@"cc_imageName"] ?: @"file";
        [formData appendPartWithFileData:imgData name:imgName fileName:[imgName stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(finished)finished([JKNetWorkResult resultWithResultObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(finished)finished([JKNetWorkResult resultWithError:error]);
    }];
}

+ (NSDictionary *)setHeadersWithUrlpath:(NSString *)urlPath parameters:(NSDictionary *_Nullable)parameters client:(AFHTTPSessionManager *)client {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    NSString *appChannel = kAppChannel;
#if DEBUG
    appChannel = kAppChannelDebug;
#else
    appChannel = kAppChannel;
#endif
    //    NSString *source = [NSString stringWithFormat:@"%@;%@;%@",@"0",kAppVersion,appChannel];
    //    [dict setValue:source forKey:@"source"];
    //    [dict setValue:[JKTools idfv] forKey:@"deviceId"];
    //    [dict setValue:[JKTools getIPAddress:YES] forKey:@"ip"];
    [dict setValue:kPPGameChannelKey forKey:@"channelKey"];
    YCJToken *userToken = [SKUserInfoManager sharedInstance].userTokenModel;
    if(userToken.accessToken.length > 0) {
        [dict setValue:userToken.accessToken forKey:@"accessToken"];
    }
    /*
     language参数，
     中文：zh-CN
     繁体：zh-TW
     英文：en
     */
    NSString *language = @"en";
    if([SJLocalTool getCurrentLanguage] == 1) {
        language = @"zh-CN";
    } else if ([SJLocalTool getCurrentLanguage] == 2) {
        language = @"zh-TW";
    } else if ([SJLocalTool getCurrentLanguage] == 3) {
        language = @"en";
    }
    [dict setValue:language forKey:@"language"];
    return dict;
  
}


@end
