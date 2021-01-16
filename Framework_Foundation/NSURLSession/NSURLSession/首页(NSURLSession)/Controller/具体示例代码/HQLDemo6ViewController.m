//
//  HQLDemo6ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo6ViewController.h"

@interface HQLDemo6ViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation HQLDemo6ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - IBActions

- (IBAction)createTask:(id)sender {
    // 请求路径
    NSURL *url = [NSURL URLWithString:@"https://op.juhe.cn/shanghai/hospital"];
    
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"POST";
    // 设置请求体
    NSString *stringBody = @"dtype=&key=5718abc3837ecb471c5d5b1ef1e35130";
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1.创建 NSURLSessionConfiguration
    NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    // 2.创建 NSURLSession
    NSURLSession *session =
        [NSURLSession sessionWithConfiguration:configuration
                                      delegate:self
                                 delegateQueue:nil];
    
    // 3.创建 NSURLSessionDataTask
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    // 4.执行 Task
    [dataTask resume];
}


#pragma mark - NSURLSessionDelegate

// 请求失败调用
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

// 处理身份验证和凭据
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

// 后台任务下载完成后调用
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

#pragma mark - NSURLSessionDataDelegate

// 接收到服务器响应的时候调用
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    // 默认情况下不接收数据，必须告诉系统是否接收服务器返回的数据
    /**
     typedef NS_ENUM(NSInteger, NSURLSessionResponseDisposition) {
     NSURLSessionResponseCancel = 0, // 默认，表示不接收数据
     NSURLSessionResponseAllow = 1,   // 接受数据
     NSURLSessionResponseBecomeDownload = 2,
     NSURLSessionResponseBecomeStream NS_ENUM_AVAILABLE(10_11, 9_0) = 3,
     }
     */
    completionHandler(NSURLSessionResponseAllow);
}

// 当请求完成之后调用，如果是因为请求失败而完成的，则 error 有值
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
}

// 接受到服务器返回数据的时候调用,可能被调用多次
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {    
    // 处理返回的 data 数据
}

@end
