//
//  HQLHTMLDemo1ViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/6/11.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLHTMLDemo1ViewController.h"

// Frameworks
#import <WebKit/WebKit.h>
#import <GRMustache.h>
#import <Masonry.h>

@interface HQLHTMLDemo1ViewController ()
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HQLHTMLDemo1ViewController

#pragma mark - View life cycle

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 通过模版引擎渲染得到内容
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSString *htmlString = [self renderTemplateWithName:@"我是一级标题名称" value:@"我是页面内容"];
    [self.webView loadHTMLString:htmlString baseURL:bundleURL];
}


#pragma mark - Custom Accessors

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        // 自适应字体
        NSString *javaScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *contentController = [[WKUserContentController alloc] init];
        [contentController addUserScript:userScript];
        _webViewConfiguration.userContentController = contentController;
    }
    return _webViewConfiguration;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:self.webViewConfiguration];
    }
    return _webView;
}


#pragma mark - Private

- (NSString *)renderTemplateWithName:(NSString *)name value:(NSString *)value {
    // 1.读取 template.html 文件
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *url = [bundleURL URLByAppendingPathComponent:@"template.html"];
    NSString *template = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    // 2.要渲染的数据
    NSDictionary *renderObject = @{ @"name": name, @"content": value };
    
    // 3.生成渲染数据
    NSString *content = [GRMustacheTemplate renderObject:renderObject fromString:template error:nil];
    return content;
}


@end
