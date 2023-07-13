#import <Foundation/Foundation.h>
#import "SDRequestBaseProtocol.h"
@interface PPRequestBaseModel : NSObject<SDRequestBaseProtocol>
@property (nonatomic, copy, readonly) NSString * taskKey;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * key;
- (NSString * )requestGETHttpURL;
@end
