
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJSignInDetailModel : NSObject
@property(nonatomic,copy) NSString *points;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *type;
@end


@interface YCJSignInListModel : NSObject

@property(nonatomic,copy) NSArray<YCJSignInDetailModel *> *list;
@property(nonatomic,copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
