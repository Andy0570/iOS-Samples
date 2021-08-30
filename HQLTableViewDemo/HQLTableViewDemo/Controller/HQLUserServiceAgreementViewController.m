//
//  HQLUserServiceAgreementViewController.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/8/24.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLUserServiceAgreementViewController.h"

// Frameworks
#import <WebKit/WebKit.h>
#import <GRMustache.h>
#import <Masonry.h>

@interface HQLUserServiceAgreementViewController ()
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HQLUserServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"海店街用户协议";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self renderTemplateData];
}

- (void)renderTemplateData {
    // 1.读取本地 UserServiceAgreement.txt 文件
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *fileURL = [bundleURL URLByAppendingPathComponent:@"UserServiceAgreement.txt"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // 2.要渲染的数据
    NSDictionary *renderObject = @{
        @"content" : string,
    };
    
    // 3.渲染 main bundle 中的 `PrivacyPolicyTemplate.mustache` 模版文件
    NSError *error = nil;
    NSString *content = [GRMustacheTemplate renderObject:renderObject
                                            fromResource:@"PrivacyPolicyTemplate"
                                                  bundle:nil
                                                   error:&error];
    
    // 通过 WebView 加载内容
    [self.webView loadHTMLString:content baseURL:nil];
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
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.webViewConfiguration];
    }
    return _webView;
}

@end
