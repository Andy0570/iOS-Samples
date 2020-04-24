//
//  HQLDemo4ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo4ViewController.h"

@interface HQLDemo4ViewController ()

// 查询 IP 地址归属地，返回 JSON 数据
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation HQLDemo4ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - IBActions

// MARK: 发起 GET 请求
- (IBAction)createGetTask:(id)sender {
    // MARK: 1.封装请求路径，查询 IP 地址
    // 接口来源：<https://dog.ceo/dog-api/>
    NSURL *url = [NSURL URLWithString:@"https://dog.ceo/api/breeds/image/random"];
    
    // MARK: 2.创建 NSURLSession，使用共享 Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // MARK: 3.创建 NSURLSessionDataTask 对象, 默认 GET 请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }else {
            
            // !!!: 主线程执行 UI 更新
            dispatch_async(dispatch_get_main_queue(), ^{
                self.resultLabel.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            });
        }
    }];
    
    // MARK: 4.执行任务
    [dataTask resume];
}




@end
