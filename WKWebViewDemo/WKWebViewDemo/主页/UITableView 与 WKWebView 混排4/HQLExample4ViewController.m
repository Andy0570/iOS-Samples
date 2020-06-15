//
//  HQLExample4ViewController.m
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLExample4ViewController.h"
#import <WebKit/WebKit.h>
#import <YYKit.h>
#import "CommentTableViewController.h"

static NSString * const KObserverContentSize = @"contentSize";

@interface HQLExample4ViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) CommentTableViewController *tableViewController;
@property(nonatomic, strong) UIView *placeHolderHeadView;
@end

@implementation HQLExample4ViewController

#pragma mark - View life cycle

- (void)dealloc {
    [self.webView stopLoading];
    self.webView.navigationDelegate = nil;
    [self.webView.scrollView removeObserver:self forKeyPath:KObserverContentSize];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.tableViewController.tableView];
    self.tableViewController.tableView.tableHeaderView = self.placeHolderHeadView;
    // !!!: 这句可以使得tableHead的触摸事件穿透给webview，而不影响其他cell的正常点击！
    self.tableViewController.tableView.tableHeaderView.userInteractionEnabled = NO;
    
    [self loadHTMLString];
}

- (void)loadHTMLString {
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
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
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:self.webViewConfiguration];
        _webView.backgroundColor = [UIColor yellowColor];
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

- (CommentTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[CommentTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableViewController.view.frame = self.view.bounds;
        // MARK: TableView 列表视图的背景颜色也需要设置为透明
        _tableViewController.tableView.backgroundColor = [UIColor clearColor];
        // 超出headView之后,webview自身不能滚动，它的contentOffset随着tableView而变
        __weak __typeof(self)weakSelf = self;
        _tableViewController.tableDidScrollBlock = ^(CGPoint contentOffset) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.webView.scrollView.contentOffset = contentOffset;
        };
    }
    return _tableViewController;
}

- (UIView *)placeHolderHeadView {
    if (!_placeHolderHeadView) {
        _placeHolderHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        // MARK: 将占位的 header view 设置为透明视图
        _placeHolderHeadView.backgroundColor = [UIColor clearColor];
    }
    return _placeHolderHeadView;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KObserverContentSize]) {
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        
        CGFloat width = self.view.frame.size.width;
        self.webView.frame = CGRectMake(0, 0, width, height);
        
        // 根据 WebView 的 frame 动态调整 TableView 的 “透明占位 header View” 的高度
        self.placeHolderHeadView.frame = CGRectMake(0, 0, width, height);
        [self.tableViewController.tableView beginUpdates];
        // self.tableViewController.tableView.tableHeaderView = self.placeHolderHeadView;
        self.tableViewController.tableView.tableHeaderView.height = height;
        [self.tableViewController.tableView endUpdates];
    }
}


#pragma mark - WKNavigationDelegate




#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView.superview isKindOfClass:[WKWebView class]]) {
        
        self.tableViewController.tableView.contentOffset = scrollView.contentOffset;
        self.webView.scrollView.contentSize = CGSizeMake(self.tableViewController.tableView.contentSize.width, self.tableViewController.tableView.contentSize.height);
        return;
    }
}

@end
