//
//  SDAppleLoginModule.m
//  SDGameForwawajiUniPlugin
//
//  Created by sander shan on 2023/1/6.
//

#import "SDAppleLoginModule.h"
#import <AuthenticationServices/AuthenticationServices.h>

#import "UniResponseModel.h"

@interface SDAppleLoginModule ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>


@end
@implementation SDAppleLoginModule

- (instancetype)initWithDelegate:(id<AppleLoginDelegate>) app_delegate
{
    self = [super init];
    if (self) {
        self.delegate = app_delegate;
    }
    return self;
}

- (void)appleLogin {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (@available(iOS 13.0, *)) {
              ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
              ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
              // 用户授权请求的联系信息
              appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
              ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
              // 设置授权控制器通知授权请求的成功与失败的代理
              authorizationController.delegate = self;
              // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
              authorizationController.presentationContextProvider = self;
              // 在控制器初始化期间启动授权流
              [authorizationController performRequests];
          } else {
              NSLog(@"该系统版本不可用Apple登录");
              UniResponseModel * response = [[UniResponseModel alloc] init];
              response.code = -1;
              response.msg = @"该系统版本不可用Apple登录";
              if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginByApple:)]) {
                  [self.delegate loginByApple:response];
              }
          }
    });
    
}
#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
  if (@available(iOS 13.0, *)) {
          if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
              
              // 用户登录使用ASAuthorizationAppleIDCredential
              ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
              NSString *user = appleIDCredential.user;
              // 获取用户相关信息
              // 暂未使用
              // NSString *state = appleIDCredential.state;
              
              // 暂未使用
              // NSArray *authorizedScopes = appleIDCredential.authorizedScopes;
              
              // 用于判断当前登录的苹果账号是否是一个真实用户，ASUserDetectionStatusLikelyReal时可用
              // ASUserDetectionStatus realUserStatus = appleIDCredential.realUserStatus;
              
              // 用户信息
              /*
              NSString *familyName = appleIDCredential.fullName.familyName;
              NSString *givenName = appleIDCredential.fullName.givenName;
              NSString *email = appleIDCredential.email;*/

              // 请求服务器验证时需要使用的参数
              NSData *identityToken = appleIDCredential.identityToken;
              NSData *authorizationCode = appleIDCredential.authorizationCode;
      
              NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
              NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
              NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
            
//            NSDictionary * params = @{@"identityToken": identityTokenStr};
              
              UniResponseModel * response = [[UniResponseModel alloc] init];
              response.code = 0;
              response.msg = @"成功";
              response.idToken = identityTokenStr;
              if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginByApple:)]) {
                  [self.delegate loginByApple:response];
              }
          }
      } else {
          // Fallback on earlier versions
      }
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
  NSLog(@"Handle error：%@", error);
      NSString *errorMsg = nil;
      switch (error.code) {
          case ASAuthorizationErrorCanceled:
              errorMsg = @"用户取消了授权请求";
              break;
          case ASAuthorizationErrorFailed:
              errorMsg = @"授权请求失败";
              break;
          case ASAuthorizationErrorInvalidResponse:
              errorMsg = @"授权请求响应无效";
              break;
          case ASAuthorizationErrorNotHandled:
              errorMsg = @"未能处理授权请求";
              break;
          case ASAuthorizationErrorUnknown:
              errorMsg = @"授权请求失败未知原因";
              break;
              
          default:
              break;
      }
  NSLog(@"****************************** %@",errorMsg);
    
    UniResponseModel * response = [[UniResponseModel alloc] init];
    response.code = -1;
    response.msg = errorMsg;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginByApple:)]) {
        [self.delegate loginByApple:response];
    }
}
#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
  // 返回window
  UIViewController * rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
  return rootViewController.view.window;
}


@end
