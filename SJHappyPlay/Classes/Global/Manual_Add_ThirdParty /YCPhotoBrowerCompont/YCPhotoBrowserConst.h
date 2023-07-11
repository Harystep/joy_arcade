
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , YCPhotoSourceType) {
    YCPhotoSourceType_Image = 0,    //直接赋值image
    YCPhotoSourceType_URL,          //不修改url直接网络获取
    YCPhotoSourceType_AlterURL,     //修改url后网络获取（用于获取高清图）
};

#define ScreenW                   [UIScreen mainScreen].bounds.size.width
#define ScreenH                   [UIScreen mainScreen].bounds.size.height


