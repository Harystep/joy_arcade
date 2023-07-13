#import "PPNetworkService.h"
#import "AFNetworking.h"
#import "PPRequestBaseModel.h"
#import "PPNetworkStatus.h"
#import "MJExtension.h"
#import "AppDefineHeader.h"
#import "PPSandBoxHelper.h"

@interface PPNetworkService()
@property (nonatomic, strong) NSMutableDictionary<__kindof NSString *, __kindof NSURLSessionTask *> *taskStack;
@end
static PPNetworkService * instance;
@implementation PPNetworkService
+ (PPNetworkService *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPNetworkService alloc] init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
#pragma mark - lazy get taskStack
- (NSMutableDictionary<__kindof NSString *, __kindof NSURLSessionTask *> *)taskStack
{
    if (!_taskStack) {
        _taskStack = [[NSMutableDictionary alloc] init];
    }
    return _taskStack;
}
#pragma mark - public
+ (void)sd_requestWithModel:(__kindof PPRequestBaseModel *)requestModel callBack:(SDRequestCallBack)responseCallBack
{
    if ([PPNetworkStatus sharedInstance].canReachable) {
        PPError * error = [PPError defineNotNetWork];
        responseCallBack(nil,error);
    }
    NSURLSessionTask * old_task = [self sharedInstance].taskStack[[requestModel taskKey]];
    if (old_task) {
        DLog(@"这个和上一个请求是一样的，别tm点了");
        return;
    }
    NSString * requestUrl = [requestModel requestUrl];
    NSDictionary * params = [requestModel mj_keyValues];
    DLog(@"请求的url = %@, params = %@",requestUrl,params);
    __kindof AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequestBean:requestModel];
    [self configHttpHeaderWithRequestBean:requestModel requestSerializer:requestSerializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"application/msexcel", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    [self showHub:requestModel message:@"请求中。。。"];
   __block NSURLSessionTask *requestTask = nil;
    __weak __typeof__(self) weakSelf = self;
    void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissHub:requestModel];
        [strongSelf handleSuccessWithRequestBean:requestModel response:responseObject callBack:responseCallBack];
        [strongSelf stopRequestTaskWithTaskKey:@[[requestModel taskKey]]];
    };
    void (^FailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissHub:requestModel];
        [strongSelf handleFailureWithError:error callBack:responseCallBack];
        [strongSelf stopRequestTaskWithTaskKey:@[[requestModel taskKey]]];
    };
    void (^ RequestHttpBlock)(void) = ^(void) {
        switch ([requestModel httpMethod]) {
            case HTTP_METHOD_GET:
            requestTask = [manager GET:requestUrl parameters:params headers:nil progress:nil success:SuccessBlock failure:FailBlock];
                break;
            case HTTP_METHOD_POST:
                if ([requestModel constructingBodyBlock]) {
                  requestTask = [manager POST:requestUrl parameters:params headers:nil constructingBodyWithBlock:[requestModel constructingBodyBlock] progress:nil success:SuccessBlock failure:FailBlock];
                }else{
                  requestTask = [manager POST:requestUrl parameters:params headers:nil progress:nil success:SuccessBlock failure:FailBlock];
                }
                break;
            default:
                NSLog(@"unknow http method");
                break;
        }
    };
    if ([requestModel cacheResponse]) {
        [self cacheWithRequestWithBean:requestModel callBack:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            if (responseModel) {
                [strongSelf dismissHub:requestModel];
                [strongSelf handleSuccessWithRequestBean:requestModel response:responseModel callBack:responseCallBack];
                [strongSelf stopRequestTaskWithTaskKey:@[[requestModel taskKey]]];
            }else{
                RequestHttpBlock();
            }
        }];
    }else{
        RequestHttpBlock();
    }
    DLog(@"生成一个任务列表 %@ %@ %@",requestTask,requestModel,[requestModel taskKey]);
    if (requestTask != nil && requestModel != nil && [requestModel taskKey] !=nil) {
        [[self sharedInstance].taskStack setObject:requestTask forKey:[requestModel taskKey]];
    }
}
#pragma mark - private
+ (__kindof AFHTTPRequestSerializer *)requestSerializerWithRequestBean:(__kindof PPRequestBaseModel *)requestBean
{
    __kindof AFHTTPRequestSerializer *requestSerializer;
    switch ([requestBean requestSerialization]) {
        case HTTP_REQUEST_SERIALIZATION_FORM:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case HTTP_REQUEST_SERIALIZATION_JSON:
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case HTTP_REQUEST_SERIALIZATION_PROPERTY_LIST:
            requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        default:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET",@"HEAD", nil];
            break;
    }
    requestSerializer.timeoutInterval = [requestBean timeout];
    return requestSerializer;
}
#pragma mark - config http header
+ (void)configHttpHeaderWithRequestBean:(__kindof PPRequestBaseModel *)requestBean requestSerializer:(__kindof AFHTTPRequestSerializer *)requestSerializer
{
    NSDictionary *headerFieldValueDictionary = [requestBean httpHeader];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
        NSString *language = @"en";
        if([PPSandBoxHelper getCurrentLanguage] == 1) {
            language = @"zh-CN";
        } else if ([PPSandBoxHelper getCurrentLanguage] == 2) {
            language = @"zh-TW";
        } else if ([PPSandBoxHelper getCurrentLanguage] == 3) {
            language = @"en";
        }
        [requestSerializer setValue:language forHTTPHeaderField:@"language"];
    }
}
#pragma mark - Hub
+ (void)showHub:(PPRequestBaseModel *)requestBean message:(NSString * )message
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([requestBean isShowHub]) {
        id delegate = [PPNetworkConfig sharedInstance].hubDelegate;
        if ([delegate respondsToSelector:@selector(showHub:)]) {
            [delegate showHub:message];
        }
    }
  });
}
+ (void)dismissHub:(PPRequestBaseModel *)requestBean
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([requestBean isShowHub]) {
        id delegate = [PPNetworkConfig sharedInstance].hubDelegate;
        if ([delegate respondsToSelector:@selector(dissmissHub)]) {
            [delegate dissmissHub];
        }
    }
  });
}
#pragma mark - 停止 请求
+ (void)stopRequestTaskWithTaskKey:(NSArray<__kindof NSString *> *)taskKeyArray
{
    if (!taskKeyArray) {
        return;
    }
    for (NSString *taskKey in taskKeyArray) {
        NSURLSessionTask *task = [[self sharedInstance].taskStack objectForKey:taskKey];
        if (task) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [task cancel];
            }
            [[self sharedInstance].taskStack removeObjectForKey:taskKey];
        }
    }
}
#pragma mark - <结果处理>
+ (void)handleSuccessWithRequestBean:(__kindof PPRequestBaseModel *)requestBean response:(id  _Nullable) responseObject callBack:(SDRequestCallBack)callBack
{
    if (!responseObject) {
        PPError *err = [[PPError alloc] initWithErrorMessage:@"no response data"];
        callBack(nil, err);
        return;
    }
  NSLog(@"请求 url -> %@ ｜｜｜｜｜｜ 结果 ： %@", requestBean.requestUrl, responseObject);
    Class responseClass = [requestBean responseClass];
    PPResponseBaseModel *  responseBean = [responseClass mj_objectWithKeyValues:responseObject];
    BOOL result = true;
    if (![requestBean checkResponseSucess]) {
        result = true;
    }else{
       result = [responseBean checkSuccess];
    }
  if ([responseBean.errCode integerValue] == 401) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login_status_error" object:responseObject];
  }
    if (result) {
        if ([requestBean cacheResponse]) {
            [self saveCacheWithRequestModel:requestBean responseObj:responseObject];
        }
        callBack(responseBean, nil);
    }else{
        PPError *err = [[PPError alloc] initWithErrorMessage:responseObject[@"errMsg"]];
        NSString * quest_string = requestBean.requestUrl;
        NSString * warning_string = [NSString stringWithFormat:@"请求失败 %@ ",quest_string];
        if (responseBean.errMsg) {
            warning_string = [warning_string stringByAppendingString:responseBean.errMsg];
        }
        callBack(responseBean, err);
    }
}
+ (void)handleFailureWithError:(NSError *)error callBack:(SDRequestCallBack)callBack
{
    PPError *err = [[PPError alloc] initWithErrorMessage:@"请求失败"];
    callBack(nil, err);
}
#pragma mark - 缓存处理
+ (void)saveCacheWithRequestCacheKey:(NSString *)taskKey responseObj:(id  _Nullable) responseObject
{
}
+ (void)saveCacheWithRequestModel:(__kindof PPRequestBaseModel * )requestModel responseObj:(id  _Nullable) responseObject
{
}
+ (void)removeCacheWithkey:(NSString * )request_key finish:(void(^)(void))finish
{
    if (request_key) {
    }
}
+ (void)cacheWithRequestWithCacheKey:(NSString  *)cacheKey withResponseClass:(Class)responseClass callBack:(SDRequestCallBack)callBack
{
}
+ (void)cacheWithRequestWithBean:(__kindof PPRequestBaseModel  *)requestBean callBack:(SDRequestCallBack)callBack
{
    if ([requestBean cacheResponse]) {
        NSString *cacheKey = [requestBean taskKey];
        Class responseClass = [requestBean responseClass];
        [self cacheWithRequestWithCacheKey:cacheKey withResponseClass:responseClass callBack:callBack];
    }else{
        PPError * error = [[PPError alloc] initWithErrorMessage:@"没有缓存"];
        callBack(nil, error);
    }
}
@end
