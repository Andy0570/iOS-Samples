//
//  HQLAFDemo2ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAFDemo2ViewController.h"

// Frameworks
#import <AFNetworking.h>

@interface HQLAFDemo2ViewController ()

@end

@implementation HQLAFDemo2ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


// MARK: GET 请求

- (IBAction)createGetTask:(id)sender {
    // 网络请求的主机名
    NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
    // 默认会话配置
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 1.创建 AFHTTPSessionManager 对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:defaultConfig];
    
    // 2.构建参数，parameters 参数可以传 nil
    // 请求路径
    NSString *urlString = @"/login";
    
    // 3.Task 任务
    [manager GET:urlString parameters:nil headers:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
        // 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        // task: 通过 task 拿到响应头
        // responseObject: 请求成功返回的响应结果（AFN内部已经把响应体转换为OC对象，通常是字典或数组)
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"GET ERROR:%@",error.localizedDescription);
    }];
}


// MARK: POST 示例 1
- (IBAction)createPostTask:(id)sender {
    // 1.创建 AFHTTPSessionManager 对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:@"https://www.google.com"]];

    // 2.请求接口
    NSString *relativePaths = @"/login";
    // 2.请求参数
    NSDictionary *parameters = @{
                                 @"username":@"admin",
                                 @"password":@"123456",
                                 };
    // 3.Task 任务
    [manager POST:relativePaths parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
    }];
}


// MARK: POST 示例 2
- (IBAction)createPostTask2:(id)sender {
    // 1.创建 AFHTTPSessionManager 对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:@"https://www.google.com"]];

    // 2.请求接口
    NSString *relativePaths = @"/login";
    // 2.请求参数
    NSDictionary *parameters = @{
                                 @"username":@"admin",
                                 @"password":@"123456",
                                 };
    
    // 3.Task 任务
    [manager POST:relativePaths parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         一个接受单个参数并将数据附加到 HTTP 正文的块。
         此 block 的参数是遵守 “AFMultipartFormData” 协议的对象。
         */
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
    }];
}


@end
