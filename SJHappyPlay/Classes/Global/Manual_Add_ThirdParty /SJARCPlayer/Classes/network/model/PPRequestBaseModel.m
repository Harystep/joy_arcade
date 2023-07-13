#import "PPRequestBaseModel.h"
#import "PPResponseBaseModel.h"
#import "PPNetworkService.h"
#import "MJExtension.h"
static const NSTimeInterval HttpRequestTimeOut = 30;
@implementation PPRequestBaseModel
@synthesize taskKey = _taskKey;
#pragma mark - public
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSTimeInterval)timeout
{
    return HttpRequestTimeOut;
}
- (NSString *)requestUrl
{
    return [PPNetworkConfig sharedInstance].base_request_url;
}
- (BOOL)cacheResponse
{
    return false;
}
- (NSDictionary *)httpHeader {
    return @{
        @"channelKey": [PPNetworkConfig sharedInstance].channelKey,
    };
}
- (BOOL)isShowHub
{
    return false;
}
- (Class)responseClass
{
    return [PPResponseBaseModel class];
}
- (NSUInteger)cacheLiveSecond
{
    return 0;
}
- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_JSON;
}
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames
{
    return @[];
}
+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    NSMutableArray *ignoreArray = [NSMutableArray arrayWithArray:[self ignoredPropertyNames]];
    [ignoreArray addObject:@"taskKey"];
    [ignoreArray addObject:@"debugDescription"];
    [ignoreArray addObject:@"description"];
    [ignoreArray addObject:@"hash"];
    [ignoreArray addObject:@"superclass"];
    return ignoreArray;
}
- (NSString * )taskKey
{
    NSString * task_string = [self requestUrl];
    task_string = [task_string stringByAppendingFormat:@"%@",[[self mj_keyValues] description]];
    return [NSString stringWithFormat:@"%ld",[task_string hash]];
}
- (void)requestFinish:(SDRequestCallBack)requestCallBack
{
    [PPNetworkService sd_requestWithModel:self callBack:requestCallBack];
}
- (AFConstructingBlock)constructingBodyBlock
{
    return nil;
}
- (BOOL)checkResponseSucess
{
    return YES;
}
- (NSString * )requestGETHttpURL{
  NSString * requestUrl = [self requestUrl];
  NSDictionary * params = [self mj_keyValues];
  NSMutableString * getParams = [[NSMutableString alloc] init];
  [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if (getParams.length == 0) {
      [getParams appendString:@"?"];
    }else {
      [getParams appendString:@"&"];
    }
    [getParams appendFormat:@"%@=%@",key,obj];
  }];
  return [NSString stringWithFormat:@"%@%@",requestUrl, getParams];
}
#pragma mark - privita
@end
