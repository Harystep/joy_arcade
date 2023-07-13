#import <UIKit/UIKit.h>
#import "PPHomeBaseDataModel.h"
@interface PPHomeBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) PPHomeBaseDataModel * dataModel;
@property (nonatomic, assign) NSIndexPath* indexPath;
@property (nonatomic, assign) CGFloat height_statistics_cell;
@property (nonatomic, assign) CGFloat superViewFrameWidth;
+ (NSString *)getCellIdentifier;
- (void)loadHomeDataModel:(PPHomeBaseDataModel * )model;
@property (nonatomic, weak) UITapGestureRecognizer * simpleTapGesure;
- (void)onsimpleTapAction:(UIGestureRecognizer *)gesture;
- (void)refeshFrame;
- (UITableView *)supertableView;
@end
