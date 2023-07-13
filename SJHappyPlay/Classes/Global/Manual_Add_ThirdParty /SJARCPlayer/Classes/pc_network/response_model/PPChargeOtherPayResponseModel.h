#import "PPResponseBaseModel.h"
@class SDChargeWeiXinPayInfo;
@interface PPChargeOtherPayResponseModel : PPResponseBaseModel
@property (nonatomic, strong)NSString * data;
@end
@interface SDChargeWeiXinPayResponseModel:PPResponseBaseModel
@property (nonatomic, strong) SDChargeWeiXinPayInfo * data;
@end
@interface SDChargeWeiXinPayInfo : NSObject
@property (nonatomic, strong) NSString * app_id;
@property (nonatomic, strong) NSString * nonce_str;
@property (nonatomic, strong) NSString * partner_id;
@property (nonatomic, strong) NSString * pay_sign;
@property (nonatomic, strong) NSString * prepay_id;
@property (nonatomic, strong) NSString * signPackage;
@property (nonatomic, strong) NSString * sign_type;
@property (nonatomic, strong) NSString * time_stamp;
@end
