#import "SJPCUploadVideoRequestModel.h"
@implementation SJPCUploadVideoRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/upload/video"];
}
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames
{
    return @[@"video",@"logId"];
}
- (AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.video name:@"video" fileName:@"12312.mp4" mimeType:@"multipart/form-data"];
        [formData appendPartWithFormData:[self.logId dataUsingEncoding:NSUTF8StringEncoding] name:@"logId"];
    };
}
@end
