//
//  HQLWebViewCell.m
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLWebViewCell.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

static NSString * const KObserverContentSize = @"contentSize";

@interface HQLWebViewCell () <WKNavigationDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HQLWebViewCell


#pragma mark - View life cycle

- (void)dealloc {
    [self.webView stopLoading];
    self.webView.navigationDelegate = nil;
    [self.webView.scrollView removeObserver:self forKeyPath:KObserverContentSize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.webView];
}


#pragma mark - Custom Accessors

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *contentController = [[WKUserContentController alloc] init];
        _webViewConfiguration.userContentController = contentController;
        
        // 自适应屏幕宽度
        NSString *javaScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [contentController addUserScript:userScript];
    }
    return _webViewConfiguration;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
        _webView.opaque = NO; // 透明度
        _webView.userInteractionEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
        [_webView.scrollView addObserver:self
                              forKeyPath:KObserverContentSize
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    }
    return _webView;
}

- (void)setHTMLString:(NSString *)HTMLString {
    _HTMLString = HTMLString;
    
    [self.webView loadHTMLString:HTMLString baseURL:nil];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KObserverContentSize]) {
        
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        
        CGFloat width = self.contentView.frame.size.width;
        self.webView.frame = CGRectMake(0, 0, width, height);
        self.scrollView.frame = CGRectMake(0, 0, width, height);
        self.scrollView.contentSize = CGSizeMake(width, height);
        
        if (self.webViewCellHeightUpdateBlock) {
            self.webViewCellHeightUpdateBlock(height);
        }
    }
}




@end
