
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCJGameRoomGroup : NSObject
@property(nonatomic,copy) NSString *roomGroupId;
@property(nonatomic,copy) NSString *categoryId;
@property(nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *thumb;
@end

@interface YCJGameRoomModel : NSObject
@property(nonatomic,copy) NSString *gameId;
@property(nonatomic,copy) NSArray<YCJGameRoomGroup *> *roomGroupList;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *thumb;
@end

NS_ASSUME_NONNULL_END
