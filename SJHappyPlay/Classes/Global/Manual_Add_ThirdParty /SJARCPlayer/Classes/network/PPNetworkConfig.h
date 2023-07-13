#import <Foundation/Foundation.h>
#import "SDHubProtocol.h"
#import "PPCacheOptions.h"
typedef NS_ENUM(NSInteger, HTTP_REQUEST_SERIALIZATION)
{
    HTTP_REQUEST_SERIALIZATION_FORM,
    HTTP_REQUEST_SERIALIZATION_JSON,
    HTTP_REQUEST_SERIALIZATION_PROPERTY_LIST,
    HTTP_REQUEST_SERIALIZATION_OTHER,
};
typedef NS_ENUM(NSInteger, HTTP_METHOD)
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_HEAD,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE,
    HTTP_METHOD_PATCH
};
typedef NS_ENUM(NSInteger, HTTP_SCHEME)
{
    HTTP_SCHEME_HTTP,
    HTTP_SCHEME_HTTPS
};
@interface PPNetworkConfig : NSObject
@property (nonatomic, weak) id <SDHubProtocol> hubDelegate;
+ (PPNetworkConfig * )sharedInstance;
@property (nonatomic, strong) PPCacheOptions * cacheOptions;
@property (nonatomic, copy) NSString * base_request_url;
@property (nonatomic, copy) NSString * base_my_host;
@property (nonatomic, assign) NSInteger base_my_port;
@property (nonatomic, copy) NSString * export_review_date;

@property (nonatomic, strong) NSString * channelKey;

/// 判断当前是不是 审核中;
@property (nonatomic, assign) Boolean isAppStoreReview;

- (Boolean)inAppStoreReview;

@end
