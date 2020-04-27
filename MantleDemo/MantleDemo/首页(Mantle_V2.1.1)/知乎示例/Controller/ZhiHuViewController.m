//
//  ZhiHuViewController.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ZhiHuViewController.h"

// Model
#import "LatestModel.h"

@interface ZhiHuViewController ()

@property (nonatomic, strong) LatestModel *model;

@end

@implementation ZhiHuViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - IBActions

// JSON -> 模型
- (IBAction)modelFromJSONButtonDidClicked:(id)sender {
    
    // 发起网络请求，获取 JSON 数据
    NSString *newsURLString = @"https://news-at.zhihu.com/api/4/news/latest";
    NSURL *newsURL = [NSURL URLWithString:newsURLString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:newsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 将网络请求返回的 data 数据转换为 NSDictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        // 使用 Mantle 将 NSDictionary 转换成对应的 LatestModel 模型对象
        NSError *mantleError = nil;
        self.model = [MTLJSONAdapter modelOfClass:[LatestModel class]
                               fromJSONDictionary:dictionary
                                            error:&mantleError];
        if (error) {
            NSLog(@"error--->%@", error);
        } else {
            NSLog(@"lastNews--->\n %@", self.model);
        }
    }];
    // 执行网络请求
    [dataTask resume];
}

// 模型 -> JSON
- (IBAction)jsonFromModelButtonDidClicked:(id)sender {
    NSError *error = nil;
    // 模型 -> JSON
    NSDictionary *dictionary = [MTLJSONAdapter JSONDictionaryFromModel:self.model
                                                                 error:&error];
    if (error) {
        NSLog(@"error--->%@", error);
    } else {
        NSLog(@"JSON--->%@", dictionary);
    }
}


@end
