//
//  HQLAlipayWebViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/26.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLAlipayWebViewController.h"

// Frameworks
#import <WebKit/WebKit.h>
#import <UIAlertController+Blocks.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <YYKit/YYKit.h>
#import <Toast.h>
// 支付宝SDK
#import <AlipaySDK/AlipaySDK.h>

// ------------  JavaScript 调用原生方法名  ------------
static NSString * const KScriptNameFuncMBProgressHUD = @"funcMBProgressHUD"; // loading 加载动画

@interface HQLAlipayWebViewController () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HQLAlipayWebViewController

#pragma mark - Lifecycle

- (void)dealloc {
    // 移除 ScriptMessageHandler
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化页面，打开 URL
    NSString *urlString = @"http://example.com";
    
    if (urlString.length > 0 && [urlString isNotBlank]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                 timeoutInterval:30];
            [(WKWebView *)self.view loadRequest:request];
        });
    }
}

#pragma mark - Custom Accessors

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        
        // 创建 WKUserContentController 对象，提供 JavaScript 向 webView 发送消息的方法
        WKUserContentController *userContentColtroller = [[WKUserContentController alloc] init];
        [userContentColtroller addScriptMessageHandler:self name:KScriptNameFuncMBProgressHUD];
        _webViewConfiguration.userContentController = userContentColtroller;
    }
    return _webViewConfiguration;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                      configuration:self.webViewConfiguration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

#pragma mark - Public


#pragma mark - Private

// 通过 H5 调用支付宝支付成功后，返回字段中有个 resultDic[@"returnUrl"]，
// 客户端打开该 URL 即可向用户显示支付成功页面
- (void)loadWithUrlStr:(NSString*)urlStr {
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [(WKWebView *)self.view loadRequest:webRequest];
        });
    }
}

#pragma mark - WKNavigationDelegate

// WebView 页面中，打开支付宝支付 URL 时，进行了拦截处理，这样就可以无需集成 SDK发起支付宝支付了
// 发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // 这个方法是不集成「支付宝 SDK」，手动拦截支付 URL 发起支付宝支付的方法
    // 💡💡💡 亲测有效 💡💡💡
    // 跳转到支付宝支付
    NSString *requestUrl = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([requestUrl hasPrefix:@"alipays://"] || [requestUrl hasPrefix:@"alipay://"]) {
        NSURL *url = navigationAction.request.URL;
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    
    
    
    // 这个方法是集成 「支付宝 SDK」，通过支付宝SDK方法，打开支付 URL 的方法
    // AlipaySDK Demo 中的方法，还未测试过
    //新版本的H5拦截支付对老版本的获取订单串和订单支付接口进行合并，推荐使用该接口
    __weak __typeof(self)weakSelf = self;
    
    /**
     *  从h5链接中获取订单串并支付接口（自版本15.4.0起，推荐使用该接口）
     *
     *  urlStr     拦截的 url string
     *
     *  return YES为成功获取订单信息并发起支付流程；NO为无法获取订单信息，输入url是普通url
     */
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[navigationAction.request.URL absoluteString] fromScheme:@"appSchema" callback:^(NSDictionary *resultDic) {
        // 处理支付回调结果
        NSLog(@"%@", resultDic);
        if ([resultDic[@"isProcessUrlPay"] boolValue]) {
            
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString *urlString = resultDic[@"returnUrl"];
            [weakSelf loadWithUrlStr:urlString];
        }
    }];
    
    NSString *interceptedString = isIntercepted ? @"成功获取订单信息并发起支付流程" : @"无法获取订单信息";
    [self.view makeToast:interceptedString];
    
    return;
}



// 页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Fail Provisional Navigation Error:%@",error);
}

// 【web视图导航过程中发生错误】时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Fail Navigation Error：%@",error);
}

// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"Web Content Process Terminal:%@",NSStringFromSelector(_cmd));
}

// 权限认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKUIDelegate

// 显示 JavaScript 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [UIAlertController showAlertInViewController:self withTitle:@"温馨提示" message:message cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        completionHandler();
    }];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [UIAlertController showAlertInViewController:self withTitle:@"需要再次确认" message:message cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            completionHandler(NO);
        }else {
            completionHandler(YES);
        }
    }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@:%@",message.name,message.body);
    
//    // 微信支付
//    if ([message.name isEqualToString:KScriptNameFuncWeChatPay] && [self isSupportWechatPay]) {
//        // 解析服务端返回的支付参数
//        NSDictionary *payDictionary = [AESCipher decryptAES:message.body key:KEY];
//        HQLWechatPayRequestModel *payRequestModel = [HQLWechatPayRequestModel modelWithJSON:payDictionary];
//        // 向微信终端发起支付的消息结构体
//        PayReq *request = [[PayReq alloc] init];
//        request.partnerId = payRequestModel.partnerid;
//        request.prepayId = payRequestModel.prepayid;
//        request.package = payRequestModel.package;
//        request.nonceStr = payRequestModel.noncestr;
//        request.timeStamp = payRequestModel.timestamp;
//        request.sign = payRequestModel.sign;
//        [WXApi sendReq:request];
//    }
    
    // 支付完成，返回订单信息
    if ([message.name isEqualToString:@""]) {
        // 处理返回订单信息
    }
    
    // 显示 Loading 动画
    if ([message.name isEqualToString:KScriptNameFuncMBProgressHUD] && [message.body isNotBlank]) {
        BOOL hudState = [message.body boolValue];
        MBProgressHUD *hud;
        if (hudState) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }
}

@end
