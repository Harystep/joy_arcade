#ifndef SDNetworkHeader_h
#define SDNetworkHeader_h
#import "PPResponseBaseModel.h"
#import "PPError.h"
//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void(^SDRequestCallBack)(__kindof PPResponseBaseModel* __nullable responseModel, PPError * __nullable error);
#endif 
