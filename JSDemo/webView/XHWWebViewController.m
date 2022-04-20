//
//  XHWWebViewController.m
//  xinhua_ios
//
//  Created by wolffy on 2018/10/20.
//  Copyright © 2018 Monster_lai. All rights reserved.
//

#import "XHWWebViewController.h"
#import "BNWeakScriptMessageHandlerDelegate.h"

@interface XHWWebViewController ()

@property (nonatomic, strong) WKWebViewConfiguration *config;

@end

@implementation XHWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    self.config = config;
    config.userContentController = [[WKUserContentController alloc] init];
    [self.config.userContentController addScriptMessageHandler:[[BNWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:@"AppConfirm"];
    [self.config.userContentController addScriptMessageHandler:[[BNWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:@"getUserInformation"];
    [self.config.userContentController addScriptMessageHandler:[[BNWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:@"getUserStatus"];
    [self.config.userContentController addScriptMessageHandler:[[BNWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:@"log"];
    [self.config.userContentController addScriptMessageHandler:[[BNWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:@"shareToPlatform"];
    if (@available(iOS 14.0, *)) {
        WKWebpagePreferences * webpagePreferences = [[WKWebpagePreferences alloc]init];;
        webpagePreferences.allowsContentJavaScript = YES;
        config.defaultWebpagePreferences = webpagePreferences;
    } else {
        // Fallback on earlier versions
        config.preferences.javaScriptEnabled = YES;
    }
    config.preferences.minimumFontSize = 10.f;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88.0) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.allowsLinkPreview = NO;
    [self.view addSubview:_webView];
    _webView.opaque = NO;
    _webView.clipsToBounds = YES;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.contentMode = UIViewContentModeScaleAspectFill;
    _webView.navigationDelegate = self;
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:@"js" ofType:@"html"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [_webView loadRequest:urlRequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - <WKNavigationDelegate>
//链接开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

//当内容开始到达主帧时被调用（即将完成）
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

//收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    if ([[webView.URL absoluteString] hasPrefix:@"itms-appss://"]) {
        if ([[UIApplication sharedApplication]canOpenURL:webView.URL]) {
            [[UIApplication sharedApplication]openURL:webView.URL options:@{} completionHandler:^(BOOL success) {
                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    if (self.navigationController) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
        }
    }
}

//解决blank新起一个页面的冲突问题
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"AppConfirm"]){
        NSLog(@"web确认是否在App中打开页面:=== message.name:AppConfirm,message.body:%@",message.body);
        [self appConfirmResponse];
    }else if ([message.name isEqualToString:@"getUserInformation"]){
        NSLog(@"web拉取用户信息:=== message.name:getUserInformation,message.body:%@",message.body);
        [self getUserInfo];
    }else if([message.name isEqualToString:@"getUserStatus"]){
        NSLog(@"web拉取用户信息,不拉登录页:=== message.name:getUserStatus,message.body:%@",message.body);
        [self getUserStatus];
    }else if ([message.name isEqualToString:@"log"]){
        NSLog(@"JS交互log:=== message.name:log,message.body:%@",message.body);
    }else if ([message.name isEqualToString:@"shareToPlatform"]){
        NSLog(@"web拉取用户信息:=== message.name:shareToPlatform,message.body:%@",message.body);
    }
}

#pragma mark - JS方法

/**
 确认在App中打开链接
 */
- (void)appConfirmResponse{
    NSString *appVersion = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString * javaScript = [NSString stringWithFormat:@"didOpenInApp('%@','%@','%@')",@"1",appVersion,[UIDevice currentDevice].identifierForVendor.UUIDString];
    [self.webView evaluateJavaScript:javaScript completionHandler:nil];
}

- (void)getUserInfo{
    NSString * userInfo = [self userInfo];
    NSString * javaScript = [NSString stringWithFormat:@"loginComplete('%@')",userInfo];
    [self.webView evaluateJavaScript:javaScript completionHandler:nil];
}

- (void)loginComplete{
    NSString * userInfo = [self userInfo];
    NSString * javaScript = [NSString stringWithFormat:@"loginComplete('%@')",userInfo];
    [self.webView evaluateJavaScript:javaScript completionHandler:nil];
}

- (void)getUserStatus{
    
}

- (NSString *)userInfo{
    NSDictionary * dict =@{@"uid":@"1",
                           @"userName":@"灰太狼"
    };
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString * userInfo = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return userInfo;
}

@end
