#import "PPHomeBaseDataModel.h"
#import "PPHomeBaseTableViewCell.h"
@interface PPHomeBaseDataModel ()
@end
@implementation PPHomeBaseDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hegiht_size_cell = 145;
    }
    return self;
}
- (NSString *)CellIdentifier
{
    return [PPHomeBaseTableViewCell getCellIdentifier];
}
- (RACSubject *)done_subject
{
    if (!_done_subject) {
        _done_subject = [RACSubject subject];
    }
    return _done_subject;
}
@end
