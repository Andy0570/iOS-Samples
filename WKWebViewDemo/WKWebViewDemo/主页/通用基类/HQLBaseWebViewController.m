//
//  HQLBaseWebViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/29.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import <MBProgressHUD.h>

static NSString * const KObserverTitle = @"title";
static NSString * const KObserverEstimatedProgress = @"estimatedProgress";

@interface HQLBaseWebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation HQLBaseWebViewController

#pragma mark - Lifecycle

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:KObserverEstimatedProgress];
    [self.webView removeObserver:self forKeyPath:KObserverTitle];
}

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addProgressView];
    [self addWebViewObserver];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Custom Accessors

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度
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
        _webView.navigationDelegate = self;
        // 开启手势右划返回
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.trackTintColor = [UIColor clearColor]; // 背景颜色
        _progressView.progressTintColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0]; // 进度条颜色
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)setRequestURL:(NSURL *)requestURL {
    _requestURL = requestURL;
    
    // BOOL isURLValidate = requestURL && [requestURL.absoluteString jk_isValidUrl];
    if (_requestURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:_requestURL];
        [(WKWebView *)self.view loadRequest:request];
    }
}


#pragma mark - Private

- (void)addProgressView {
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 根据 iOS 系统版本适配高度
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@1);
    }];
}

- (void)addWebViewObserver {
    // 监听 WKWebView 对象的 estimatedProgress 进度条属性
    [self.webView addObserver:self forKeyPath:KObserverEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:KObserverTitle options:NSKeyValueObservingOptionNew context:nil];
}

- (void)showMBProgressHudWithString:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(string, @"HUD message");
    // 移动到底部中心
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    // 3秒后自动消失
    [hud hideAnimated:YES afterDelay:3.f];
}


#pragma mark - KVO

// 接收变更后的通知，计算 webView 的进度条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:KObserverEstimatedProgress]) {

        // MARK: estimatedProgress
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /**
             * 添加一个简单的动画，将progressView的Height变为1.4倍
             *
             * 动画时长0.25s，延时0.3s后开始动画
             * 动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else if ([keyPath isEqualToString:KObserverTitle]) {

        // MARK: title
        self.title = change[@"new"];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate

// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    // 防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@\n WebView 加载内容时发生错误:%@",@(__PRETTY_FUNCTION__), error.localizedDescription);
    
    [self showMBProgressHudWithString:error.localizedDescription];
    self.progressView.hidden = YES;
}

// 【web视图导航过程中发生错误】时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@\n WebView 视图导航过程中发生错误:%@",@(__PRETTY_FUNCTION__), error.localizedDescription);
    
    [self showMBProgressHudWithString:error.localizedDescription];
    self.progressView.hidden = YES;
}

// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    self.progressView.hidden = YES;
}

@end
