//
//  HQLDemo5ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo5ViewController.h"

@interface HQLDemo5ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@end

@implementation HQLDemo5ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - IBActions

// MARK: 发起 POST 请求
- (IBAction)createPostTask:(id)sender {
    // 1. 封装请求路径
    NSURL *url = [NSURL URLWithString:@"https://op.juhe.cn/shanghai/hospital"];
    
    // 2. 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 2.1 设置请求方法
    request.HTTPMethod = @"POST";
    // 2.2 设置请求体
    NSString *stringBody = @"dtype=&key=123";
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
    // 2.3 设置请求头，例如向服务器发送设备信息 @"User-Agent" 要严格按照请求内容规定请求
    [request setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"User-Agent"];
    // 2.4 设置请求超时
    [request setTimeoutInterval:10];
    
    // 3.1 创建 NSURLSession 对象，使用共享 Session
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.2 创建 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (error) {
             // error
         } else {
             // 获得数据后，返回到主线程更新 UI
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 self.dataLabel.text = responseString;
             });
         }
    }];
    // 4. 执行 Task
    [dataTask resume];
}

@end
