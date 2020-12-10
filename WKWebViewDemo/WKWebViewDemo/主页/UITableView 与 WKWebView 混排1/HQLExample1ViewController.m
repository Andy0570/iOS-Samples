//
//  HQLExample1ViewController.m
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLExample1ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

static NSString * const KObserverContentSize = @"contentSize";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";
static NSString * const webViewCellReuseIdentifier = @"webViewCellReuseIdentifier";


@interface HQLExample1ViewController () <UITableViewDataSource, UITableViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewHeight;
@end

@implementation HQLExample1ViewController


#pragma mark - View life cycle

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:KObserverContentSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    [self loadWebView];
}

- (void)addSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadWebView {
    NSURL *url = [NSURL URLWithString:@"https://fashion.ifeng.com/c/7xGSNeEJFqa"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:webViewCellReuseIdentifier];
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        webViewConfiguration.userContentController = userContentController;
        // 自适应屏幕宽度
        NSString *javaScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentController addUserScript:userScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfiguration];
        _webView.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
        _webView.opaque = NO; // 透明度
        _webView.userInteractionEnabled = NO; // 禁用用户交互
        _webView.scrollView.bounces = NO; // 禁用弹簧动画效果
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        // 监听网页的 contentSize 属性
        [_webView.scrollView addObserver:self
                              forKeyPath:KObserverContentSize
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    }
    return _webView;
}


#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4: {
            // Web Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webViewCellReuseIdentifier forIndexPath:indexPath];
            [cell addSubview:self.scrollView];
            [self.scrollView addSubview:self.webView];
            return cell;
            break;
        }
        default: {
            // Default Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"默认 cell，%lu",indexPath.row];
            return cell;
            break;
        }
    }
}


#pragma mark - <UITableViewDelegate>

// 自定义 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return _webViewHeight;
            break;
        default:
            return 50;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // when selected row of indexPath
    
}


#pragma mark - NSKeyValueObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KObserverContentSize]) {
        // 方法一，直接监听 contentSize.height 属性
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
        
        // 刷新指定位置的 cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        /*
        // 方法二，通过 document.body.offsetHeight 代码计算高度
        [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat height = [result doubleValue] + 20;
            self.webViewHeight = height;
            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
            self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
            self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
         */
    }
}


@end
