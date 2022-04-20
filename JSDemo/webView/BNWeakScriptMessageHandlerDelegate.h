//
//  BNWeakScriptMessageHandlerDelegate.h
//  TheBeijingNewsApp
//
//  Created by 陈诗杭 on 2019/11/8.
//  Copyright © 2019 Monster_lai. All rights reserved.
//  用于防止向JS中注入handler的时候强引用了self,最终导致内存泄漏 webView不销毁

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNWeakScriptMessageHandlerDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
-  (instancetype)initWithDelegate:(id<WKScriptMessageHandler>) scriptDelegate;

@end

NS_ASSUME_NONNULL_END
