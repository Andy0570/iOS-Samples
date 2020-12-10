//
//  HQLHTMLDemo2ViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/6/9.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLHTMLDemo2ViewController.h"

// Frameworks
#import <WebKit/WebKit.h>
#import <GRMustache.h>
#import <Masonry.h>


@interface HQLHTMLDemo2ViewController ()
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HQLHTMLDemo2ViewController

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

- (NSString *)renderTemplateWithName:(NSString *)name  value:(NSString *)value {
    
    // 1.要渲染的数据
    NSDictionary *renderObject = @{ @"name": name, @"content": value };

    // 2.渲染 main bundle 中的 `template.mustache` 文件
    // !!!: 注意到与示例一的区别，没有将模版文件作为字符串读取进来，而是直接加载！
    NSError *error = nil;
    NSString *content = [GRMustacheTemplate renderObject:renderObject
                                            fromResource:@"template"
                                                  bundle:nil
                                                   error:&error];
    if (!content) {
        NSLog(@"Error Occurred:\n%@",error);
    }
    return content;
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


@end
