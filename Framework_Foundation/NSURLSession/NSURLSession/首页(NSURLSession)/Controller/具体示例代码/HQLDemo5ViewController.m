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
    // 封装请求路径
    NSURL *url = [NSURL URLWithString:@"https://op.juhe.cn/shanghai/hospital"];
     
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"POST";
    // 设置请求体
    NSString *stringBody = @"dtype=&key=123";
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
     
    // 1.创建 NSURLSession 对象，使用共享 Session
    NSURLSession *session = [NSURLSession sharedSession];
    // 2.创建 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (error) {
             // error
         }else {
             // 获得数据后，返回到主线程更新 UI
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 self.dataLabel.text = responseString;
             });
         }
    }];
    // 3.执行 Task
    [dataTask resume];
}

@end
