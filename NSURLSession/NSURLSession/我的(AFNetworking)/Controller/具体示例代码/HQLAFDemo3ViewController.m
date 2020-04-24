//
//  HQLAFDemo3ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAFDemo3ViewController.h"

// Framework
#import <AFNetworking.h>
#import <YYKit/NSObject+YYModel.h>
#import "MBProgressHUD.h"

// model
#import "HQLGovermentModel.h"

// Controller
#import "HQLGovermentTableViewController.h"

// 聚合数据 - 上海市政数据
static NSString *const AppKey = @"5718abc3837ecb471c5d5b1ef1e35130";
static NSString *const URL_String = @"https://op.juhe.cn/shanghai/police";

@interface HQLAFDemo3ViewController ()

@end

@implementation HQLAFDemo3ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"POST 获取数据";
}


#pragma mark - IBActions

- (IBAction)requestButtonDidClicked:(id)sender {
    [self requestDataFromServer];
}

#pragma mark - Private

// 发起 POST 请求
- (void)requestDataFromServer {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // 1.创建 AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.构建请求参数
    NSDictionary *parameters = @{
                                 @"key":AppKey,
                                 @"dtype":@"json"
                                 };

    // 3.创建任务
    [manager POST:URL_String parameters:parameters headers:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        // 处理数据
        HQLGovermentModel *resultModel = [HQLGovermentModel modelWithJSON:responseObject];
        NSLog(@"resultModel:\n%@",resultModel);
        
        // 推入下一个视图控制器
        HQLGovermentTableViewController *govermentTableViewController = [[HQLGovermentTableViewController alloc] initWithGovermentModel:resultModel];
        [self.navigationController pushViewController:govermentTableViewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        NSLog(@"%@",error.localizedDescription);
    }];
}


@end
