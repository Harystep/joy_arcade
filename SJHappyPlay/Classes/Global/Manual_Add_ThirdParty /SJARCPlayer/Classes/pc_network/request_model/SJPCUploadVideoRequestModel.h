#import "PPRequestBaseModel.h"
@interface SJPCUploadVideoRequestModel : PPRequestBaseModel
@property (nonatomic, strong) NSData * video;
@property (nonatomic, strong) NSString * logId;
@end
