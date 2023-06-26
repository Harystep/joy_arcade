//
//  YCJBaseWebViewController.h
//  YCJieJiGame
//
//  Created by John on 2023/5/17.
//

#import "YCJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCJBaseWebViewController : YCJBaseViewController

- (instancetype)initWithUrl:(NSString *)url;

/// 跳转url
@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
