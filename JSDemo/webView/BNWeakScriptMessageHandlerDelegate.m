//
//  BNWeakScriptMessageHandlerDelegate.m
//  TheBeijingNewsApp
//
//  Created by 陈诗杭 on 2019/11/8.
//  Copyright © 2019 Monster_lai. All rights reserved.
//

#import "BNWeakScriptMessageHandlerDelegate.h"

@implementation BNWeakScriptMessageHandlerDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    if (self = [super init]) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
