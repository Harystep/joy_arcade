#import "PPRequestBaseModel.h"
@interface SJPCWeiXinLoginRequestModel : PPRequestBaseModel <SDRequestBaseProtocol>
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * oauthId;
@property (nonatomic, assign) NSInteger platform;
@end
