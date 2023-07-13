//
//  SJRequestAppleCreateOrderModel.m
//  wawajiGame
//
//  Created by oneStep on 2023/6/19.
//

#import "SJRequestAppleCreateOrderModel.h"

@implementation SJRequestAppleCreateOrderModel

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}
- (NSString * )requestUrl
{
    return [[PPNetworkConfig sharedInstance].base_request_url stringByAppendingString:@"/charge/ios/create/order"];
}
- (Class)responseClass{
    return NSClassFromString(@"SJResponseAppleCreateOrderModel");
}

- (HTTP_REQUEST_SERIALIZATION)requestSerialization
{
    return HTTP_REQUEST_SERIALIZATION_OTHER;
}


@end
