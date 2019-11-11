//
//  HQLCoursesViewController.m
//  HQLNerdfeed
//
//  Created by ToninTech on 16/8/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLCoursesViewController.h"
#import "HQLWebViewController.h"

@interface HQLCoursesViewController () <NSURLSessionDataDelegate>

/**
 *  NSURLSession
 *  含义：1.NSURLSession类；
 *       2.一组用于处理网络请求的API
 */
//保存NSURLSession对象
@property (nonatomic) NSURLSession *session;

//保存在线课程数组，数组中的每个元素都是一个 NSDictionary对象，表示一项课程的详细信息
@property (nonatomic,copy) NSArray *courses;

@end

@implementation HQLCoursesViewController

//处理web服务认证
- (void) URLSession:(NSURLSession *)session
               task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    //凭据
    NSURLCredential *cred = [NSURLCredential
                             credentialWithUser:@"BigNerdRanch"
                             password:@"AchieveNerdvana"
                             persistence:NSURLCredentialPersistenceForSession];//认证信息有效期，枚举值
    
    //完成处理程序 completionHandler(认证类型，认证信息)
    completionHandler (NSURLSessionAuthChallengeUseCredential,cred);
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    //重用UITableViewCell，向表视图注册应该使用的UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
    
    //创建NSURLSession对象
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.navigationItem.title = @"BNRCourses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config
                                            //NSURLSessionConfiguration对象
                                                 delegate:self   //委托
                                            delegateQueue:nil]; //委托队列
        [self fetchFeed];
    }
    
     return self;
}

// 获取数据方法
- (void) fetchFeed {
    
    //创建NSURLRequest请求对象
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //使用NSURLSession对象创建一个NSURLSessionDataTask对象，将NSURLRequest对象发送给服务器
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler: //block对象
                                      ^(NSData * _Nullable data,
                                        NSURLResponse * _Nullable response,
                                        NSError * _Nullable error) {
        
//        NSString *json = [[NSString alloc] initWithData:data
//                                               encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",json);
        
        /** 解析JSON数据
         *  NSJSONSerialization类：用于解析JSON数据
         *  NSJSONSerialization可以将JSON数据转换为Object-C对象
         *  字典会转换为NSDictionary对象；数组会转换为NSArray对象；字符串会转换为NSString对象；数字会转换为NSNumber对象
         */
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
//        NSLog(@"%@",jsonObject);
        //将NSDictionary代表的课程存入数组
        self.courses = jsonObject[@"courses"];
        NSLog(@"%@",self.courses);
        
        //使用dispatch_asynch函数让reloadData方法在主线程中运行
        dispatch_async(dispatch_get_main_queue(), ^{
            //重新加载UITableView对象的数据
            [self.tableView reloadData];
        });
        
    }];
    
    //NSURLSessionDataTask在刚创建的时候处于暂停状态
    [dataTask resume];  //手动调用resume方法恢复
    
}

//获取数据源
//UITableViewDataSource协议必须（@requored）实现的2个方法
////返回行数
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    
    //返回课程数目
    return self.courses.count;
}

//获取用于显示第section个表格段、第row行数据的UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建或重用UITableViewCell对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                             forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text  = course [@"title"];//设置标题
    return cell;
}

// 返回表格段数（section）目，不实现，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//用户更改选择后调用
//创建HQLWebViewController对象并将其压入UINavigationController栈
- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *course = self.courses [indexPath.row];
    
    NSURL *URL = [NSURL URLWithString:course [@"url"]];
    
    self.webViewController.title =course [@"title"];
    
    self.webViewController.URL = URL;
    
    //如果对象不属于splitViewController，则当前设备不是iPad,可以将webViewController压入navigationController栈
    if (! self.splitViewController) {
        
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
    
}

@end
