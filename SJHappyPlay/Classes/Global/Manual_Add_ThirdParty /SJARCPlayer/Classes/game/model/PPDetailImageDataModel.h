#import "PPHomeBaseDataModel.h"
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPDetailImageDataModel : PPHomeBaseDataModel
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) RACSubject * updateSubject;
@property (nonatomic, assign) NSInteger row;
- (instancetype)initWithImg:(NSString * )img;
@end
NS_ASSUME_NONNULL_END
