
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKNetWorkResult : NSObject

@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) NSDictionary *resultObject;

@property (strong, nonatomic) id resultData;

@property (nonatomic, assign) NSInteger total;

+ (instancetype)resultWithError:(NSError *)error;

+ (instancetype)resultWithResultObject:(id)resultObject;



@end

NS_ASSUME_NONNULL_END
