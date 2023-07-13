#import "SJPCExChangeBabyToDiamondRequestModel.h"
@implementation SJPCExChangeBabyToDiamondRequestModel
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/doll/diamond/exchange/part"];
}
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames
{
    return @[@"productIds",@"nums"];
}
- (AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString * productid in self.productIds) {
            [formData appendPartWithFormData:[productid dataUsingEncoding:NSUTF8StringEncoding] name:@"productIds"];
        }
        for (NSNumber * number in self.nums) {
            [formData appendPartWithFormData:[[number stringValue] dataUsingEncoding:NSUTF8StringEncoding] name:@"nums"];
        }
    };
}
@end
