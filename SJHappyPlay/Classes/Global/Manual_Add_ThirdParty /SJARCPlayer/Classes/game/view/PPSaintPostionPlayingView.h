#import <UIKit/UIKit.h>
#import "PPTcpReceviceData.h"
#import "ReactiveObjC.h"
NS_ASSUME_NONNULL_BEGIN
@interface PPSaintPostionPlayingView : UIView
@property (nonatomic, strong) NSArray<SDSaintSeatInfoModel * > * playerList;
@property (nonatomic, assign) NSInteger playerPostion;
@property (nonatomic, strong) RACSubject * theSettlementSubject;
@end
NS_ASSUME_NONNULL_END
