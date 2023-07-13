//
//  SDRechargeWebViewController.m
//  wawajiGame
//
//  Created by sander shan on 2023/5/5.
//

#import "SDRechargeWebViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "MBProgressHUD.h"

@interface SDRechargeWebViewController ()<WKNavigationDelegate>

@property (nonatomic, weak) WKWebView * theWebView;

@property (nonatomic, copy) NSString * webData;

@end

@implementation SDRechargeWebViewController


- (instancetype)initWithData:(NSString *)data
{
    self = [super init];
    if (self) {
        self.webData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.theWebView loadHTMLString:self.webData baseURL: nil];
}

#pragma mark - WKNavigationDelegate
- (void)                  webView:(WKWebView *)webView
  decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                  decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSString * url = (request.URL).absoluteString;
    if ([url hasPrefix:@"alipay://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {

        }];
        [self dismissViewControllerAnimated:true completion:nil];
    } else if ([url hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {

        }];
        [self dismissViewControllerAnimated:true completion:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)theWebView{
  if (!_theWebView) {
    WKWebView * theView = [[WKWebView alloc] init];
    [self.view addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    theView.navigationDelegate = self;
    _theWebView = theView;
  }
  return _theWebView;
}

@end
