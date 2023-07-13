#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import <UIKit/UIKit.h>
@interface PPHomeBaseDataModel : NSObject
@property (nonatomic, assign) CGFloat hegiht_size_cell;
@property (nonatomic, assign) BOOL show_bottom_line;
@property (nonatomic, strong) RACSubject * done_subject;
- (NSString *)CellIdentifier;
@end
