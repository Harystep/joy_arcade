

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SJChangeRoomListAlertViewDelegate <NSObject>
- (void)disSelectIntoRoom:(NSDictionary *)dataDic;
@end

@interface SJChangeRoomListAlertView : UIView

@property (nonatomic,copy) void (^viewClickBlock)(void);

@property (nonatomic,strong) NSArray *roomList;

@property (nonatomic,weak) id<SJChangeRoomListAlertViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
