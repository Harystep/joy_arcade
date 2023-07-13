#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface PPGamePlayerUserData : NSObject
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * avatarUrl;
- (instancetype)initWithUsername:(NSString * )userName avatarUrl: (NSString * )avatarUrl;
@end
NS_ASSUME_NONNULL_END
