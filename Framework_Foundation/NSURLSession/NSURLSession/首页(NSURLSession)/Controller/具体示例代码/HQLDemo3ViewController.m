//
//  HQLDemo3ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo3ViewController.h"

@interface HQLDemo3ViewController ()

@end

@implementation HQLDemo3ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 上传数据示例

-(IBAction)createUploadDataSession:(id)sender {
    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // 配置默认会话的缓存行为
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
    /* Note:
     iOS需要设置相对路径:〜/Library/Caches
     OS X 要设置绝对路径。
     */
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                      diskCapacity:268435456
                                                          diskPath:cachePath];
    defaultConfiguration.URLCache = cache;
    defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

    // 2.创建 NSURLSession
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:operationQueue];
    
    
    // ***************************************************************
    // 3.1 设置上传的 Data 数据
    NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
    NSData *data = [NSData dataWithContentsOfURL:textFileURL];
     
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    // 在请求头中设置 Data 数据的大小
    [mutableRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    // 在请求头中设置 Data 数据的数据类型
    [mutableRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
     
    // 4. 创建数据上传任务
    NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithRequest:mutableRequest fromData:data];
    [uploadTask resume];
}


#pragma mark - 上传文件示例

-(IBAction)createUploadFileSession:(id)sender {
    // 1.创建 NSURLSessionConfiguration
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // 配置默认会话的缓存行为
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
    /* Note:
     iOS需要设置相对路径:〜/Library/Caches
     OS X 要设置绝对路径。
     */
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                      diskCapacity:268435456
                                                          diskPath:cachePath];
    defaultConfiguration.URLCache = cache;
    defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

    // 2.创建 NSURLSession
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:operationQueue];
    
    
    // ***************************************************************
    // 3.2.上传 File
    NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
     
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
     
    // 4. 创建文件上传任务
    NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithRequest:mutableRequest fromFile:textFileURL];
    [uploadTask resume];
}


#pragma mark - 上传 Stream 流

/**
 💡 以数据流的方式上传数据的好处就是大小不受限制，上传需要服务器端脚本支持！
 */
-(IBAction)createUploadStreamSession:(id)sender {
    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // 配置默认会话的缓存行为
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
    /* Note:
     iOS需要设置相对路径:〜/Library/Caches
     OS X 要设置绝对路径。
     */
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                      diskCapacity:268435456
                                                          diskPath:cachePath];
    defaultConfiguration.URLCache = cache;
    defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

    // 2.创建 NSURLSession
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:operationQueue];
    
    // ***************************************************************    
    // 3.3.Stream 流式上传
    NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
    NSData *data = [NSData dataWithContentsOfURL:textFileURL];
     
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    mutableRequest.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:textFileURL.path];
    [mutableRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
     
    NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithStreamedRequest:mutableRequest];
    [uploadTask resume];
}

@end
