#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "PPTcpReceviceData.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPSaintPlayerWaitView : UIView
@property (nonatomic, strong) RACSubject * playerDoneSubject;
@property (nonatomic, strong) NSArray<SDSaintSeatInfoModel * > * playerList;
@end
NS_ASSUME_NONNULL_END
