//
//  SDAppleLoginModule.h
//  SDGameForwawajiUniPlugin
//
//  Created by sander shan on 2023/1/6.
//

#import <Foundation/Foundation.h>

@class UniResponseModel;

@protocol AppleLoginDelegate <NSObject>

- (void)loginByApple:(UniResponseModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SDAppleLoginModule : NSObject

@property (nonatomic, weak) id<AppleLoginDelegate> delegate;

- (instancetype)initWithDelegate:(id<AppleLoginDelegate>) app_delegate;

- (void)appleLogin;

@end

NS_ASSUME_NONNULL_END
