//
//  XHWWebViewController.h
//  xinhua_ios
//
//  Created by 拓道 on 2018/10/20.
//  Copyright © 2018 Monster_lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHWWebViewController : UIViewController <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
