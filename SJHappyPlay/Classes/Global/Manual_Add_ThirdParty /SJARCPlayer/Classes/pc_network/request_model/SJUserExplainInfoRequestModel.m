//
//  PCUserExplainInfoRequestModel.m
//  wawajiGame
//
//  Created by sander shan on 2023/3/29.
//

#import "SJUserExplainInfoRequestModel.h"
#import "PCUserExplainInfoRResponseModel.h"

@implementation SJUserExplainInfoRequestModel
- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/user/explain"];
}
- (Class)responseClass{
    return [PCUserExplainInfoRResponseModel class];
}
@end
