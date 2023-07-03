

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YJCCellDetailInfoType) {
    YCJCellDetailInfoTypeText = 0,
    YCJCellDetailInfoTypeImg = 1
};
@class YCJMineInfoModel;
typedef void(^HJCMineActionBlock)(YCJMineInfoModel *info);

@interface YCJMineInfoModel : NSObject

@property(nonatomic, copy) NSString *leftIcon;
///左边文案
@property (nonatomic, copy) NSString *leftStr;

@property(nonatomic, copy) NSString *rightIcon;
///右边文案
@property (nonatomic, copy) NSString *rightStr;
///是否隐藏右箭头
@property (nonatomic, assign) BOOL isHiddenArrows;

@property(nonatomic, strong) UIImage *placeHolderImg;

@property(nonatomic, assign) YJCCellDetailInfoType detailInfoType;

@property(nonatomic, copy) Class destinationClass;

@property(nonatomic, copy) HJCMineActionBlock actionBlock;

+ (instancetype)modelWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr;

+ (instancetype)modelWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass;

+ (instancetype)modelWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass;

- (instancetype)initWithLeftIcon:(NSString *)leftIcon leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass;

- (instancetype)initWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr destinationClass:(Class)destinationClass;

@end


NS_ASSUME_NONNULL_END
