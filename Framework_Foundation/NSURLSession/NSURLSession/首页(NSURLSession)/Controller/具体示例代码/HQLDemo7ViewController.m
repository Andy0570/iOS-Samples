//
//  HQLDemo7ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo7ViewController.h"

@interface HQLDemo7ViewController ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HQLDemo7ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建NSURLSession对象
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    //发起网络请求获取新闻
    [self fetchHrssnews];
}


#pragma mark - 获取新闻数据

- (void)fetchHrssnews {
    
    // 创建NSURLRequest对象
    NSString *requestString = @"https://example.com/api/v1/news";
    NSURL *url = [NSURL URLWithString:requestString];
    
    /**
     方法参数
     
     * 统一资源定位符：接口 URL 地址
     * 缓存策略：忽略本地缓存、
     * 等待 web 服务器响应最长时间
     */
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:60.0f];
    // 设置请求方式为 POST
    [req setHTTPMethod:@"POST"];
    
    // 告诉服务器数据为 JSON 类型
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求体
    NSString *dataString = @"ksym=0&jsym=15";
    NSData *postData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:postData];
    
    // 创建 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 解析 JSON 数据：JSON -> NSDictionary
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // msgflag 是业务状态码，0 表示响应正常，1 表示响应错误。
        NSString *msgflag = jsonObject[@"msgflag"];
        // msg 是返回的具体业务数据
        __unused NSString *msg = jsonObject[@"msg"];
        
        //判断是否成功获取服务器端数据
        if ([msgflag isEqualToString:@"0"]) {
            // 返回数据成功，继续
        }else{
            // 返回数据错误，提示用户
        }
        
        // 使用 dispatch_asynch 函数让 reloadData 方法在主线程中运行
        dispatch_async(dispatch_get_main_queue(), ^{
            //重新加载UITableView对象的数据
            // [self.tableView reloadData];});
            //停止刷新
            // [self.tableView.mj_header endRefreshing];
        });
    }];
    
    // NSURLSessionDataTask 在刚创建的时候默认处于挂起状态，需要手动调用恢复。
    [dataTask resume];
}

@end
