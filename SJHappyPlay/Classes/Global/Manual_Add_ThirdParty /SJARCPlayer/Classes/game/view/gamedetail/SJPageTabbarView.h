#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface SJPageTabbarView : UIView
@property (nonatomic, strong) NSArray<NSString *> * tabList;
@property (nonatomic, assign) NSInteger currentTab;
@property (nonatomic, strong) RACSubject * tabSubject;
- (instancetype)initWithTab:(NSArray <NSString * > * ) list;
@end
NS_ASSUME_NONNULL_END
