#import "SJPCUploadImageRequestModel.h"
#import "AFNetworking.h"
#import "PPNetworkStatus.h"
@implementation SJPCUploadImageRequestModel
- (NSString * )requestUrl{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/upload/image"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames
{
    return @[@"image"];
}
- (Class)responseClass
{
    return NSClassFromString(@"PPUploadImageResponseModel");
}
- (AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.image name:@"image" fileName:@"12312.png" mimeType:@"multipart/form-data"];
    };
}
@end
