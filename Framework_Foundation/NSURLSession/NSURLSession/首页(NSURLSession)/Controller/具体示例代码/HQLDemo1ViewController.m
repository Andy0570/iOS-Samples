//
//  HQLDemo1ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo1ViewController.h"

@interface HQLDemo1ViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation HQLDemo1ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - 默认会话

- (IBAction)CreateDefaultSession:(id)sender {
    // MARK: 1.创建 NSURLSessionConfiguration 对象，进行 Session 会话配置
    // 默认会话配置
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // MARK: 2.配置默认会话的缓存行为
    // Caches 目录：NSCachesDirectory
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    // 在 Caches 目录下创建创建子目录
    NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
    /*
     Note:
     iOS 需要设置相对路径:〜/Library/Caches
     OS X 要设置绝对路径。
     */
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                      diskCapacity:268435456
                                                          diskPath:cachePath];
    defaultConfig.URLCache = cache;
    defaultConfig.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    // MARK: 3.创建 NSURLSession 对象
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig
                                                                 delegate:nil
                                                            delegateQueue:operationQueue];
    
    // MARK: 4.创建 NSURLSessionTask
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLSessionTask *sessionTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 响应对象是一个 NSHTTPURLResponse 对象实例
        NSLog(@"Got response %@ with error %@.\n", response, error);
        NSLog(@"默认会话返回数据:\n%@ \nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // MARK: 开启任务
    [sessionTask resume];
}


#pragma mark - 短暂会话

- (IBAction)CreateEphemeralSession:(id)sender {
    // MARK: 1.创建 NSURLSessionConfiguration 对象，进行 Session 会话配置
    // 短暂会话配置
    NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];

    // MARK: 2.创建 NSURLSession 对象
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

    NSURLSession *ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfig
                                                                   delegate:nil
                                                              delegateQueue:operationQueue];

    // MARK: 3.创建 NSURLSessionTask
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLSessionTask *sessionTask = [ephemeralSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Got response %@ with error %@.\n", response, error);
        NSLog(@"短暂会话返回数据:\n%@\nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // MARK: 开启任务
    // NSURLSessionDataTask 在刚创建的时候默认处于挂起状态，需要手动调用恢复。
    [sessionTask resume];
}



#pragma mark - 后台会话

// !!!: 如果你创建了一个后台会话，必须使用代理来接收数据！！！
/**
 如果还是向上面一样创建会话，应用会崩溃：
 Completion handler blocks are not supported in background sessions. Use a delegate instead
 */
- (IBAction)CreateBackgroundSession:(id)sender {
    // MARK: 1.创建 NSURLSessionConfiguration 对象，进行 Session 会话配置
    // 后台会话配置
    NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.myapp.networking.background"];
    
    // MARK: 2.配置后台会话的缓存行为
    // Caches 目录：NSCachesDirectory
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    // 在 Caches 目录下创建创建子目录
    NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
    
    /*
     Note:
     iOS 需要设置相对路径:〜/Library/Caches
     OS X 要设置绝对路径。
     */
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                      diskCapacity:268435456
                                                          diskPath:cachePath];
    backgroundConfig.URLCache = cache;
    backgroundConfig.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    // MARK: 3.创建 NSURLSession 对象
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfig
                                                                    delegate:self
                                                               delegateQueue:operationQueue];
    
    // MARK: 4.创建 NSURLSessionTask
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLSessionTask *sessionTask = [backgroundSession dataTaskWithURL:url];
    
    // MARK: 开启任务
    [sessionTask resume];
}


#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    // 请求失败调用。
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 处理身份验证和凭据。
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    // 后台任务下载完成后调用
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    // 接收到服务器响应的时候调用
    // 默认情况下不接收数据，必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    // 请求失败调用
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    // 接受到服务器返回数据的时候调用,可能被调用多次
    NSLog(@"后台会话返回数据:\n%@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}


@end
