

#import "QABaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QABaseWebViewController : QABaseViewController

- (instancetype)initWithUrl:(NSString *)url;

/// 跳转url
@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
