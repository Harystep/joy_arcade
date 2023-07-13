//
//  UniResponseModel.h
//  SDGameForwawajiUniPlugin
//
//  Created by sander shan on 2023/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniResponseModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSString * msg;

@property (nonatomic, strong) NSString * idToken;


@end

NS_ASSUME_NONNULL_END
