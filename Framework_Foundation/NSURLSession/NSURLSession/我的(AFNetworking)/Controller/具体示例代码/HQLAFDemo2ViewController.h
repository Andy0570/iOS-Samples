//
//  HQLAFDemo2ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 AFHTTPSessionManager 示例代码
 */
@interface HQLAFDemo2ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/// GET 请求示例 MARK
/**
// 请求接口
NSURL *baseURL = [NSURL URLWithString:URL_HOST];
NSURL *requestURL = [NSURL URLWithString:URL_1_6_3_1 relativeToURL:baseURL];
DDLogInfo(@"request url:%@",requestURL.absoluteString);

// 1.创建 AFHTTPSessionManager 对象
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
// 2.构造查询参数
NSDictionary *parameters = @{
                             @"citycode":@"320200",
                             @"page":@1,
                             @"limit":@10
                             };
// 3.创建 Task 任务
[manager GET:requestURL.absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [self.tableView.mj_header endRefreshing];
    
    DDLogVerbose(@"%@",responseObject);
    NSNumber *code = [responseObject objectForKey:@"code"];
    BOOL isResponseNormal = [code intValue] == 0;
    
    // 业务数据请求异常
    if (!isResponseNormal) {
        self.emptyDataTitle = @"请求数据失败";
        
        // FIXME: 跳转到主线程刷新数据
        [self.tableView reloadEmptyDataSet];
        return;
    }
    
    // 业务数据请求成功
    NSError *error = nil;
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:HQLMarketModel.class
                                          fromJSONArray:responseObject[@"data"]
                                                  error:&error];
    if (error) {
        DDLogError(@"JSON 数据转换发生错误:\n%@",error);
        
        self.emptyDataTitle = @"JSON 数据转换发生错误";
        
        // FIXME: 跳转到主线程刷新数据
        [self.tableView reloadEmptyDataSet];
        
        return;
    }
    
    [self.dataSourceArray addObjectsFromArray:modelArray];
    [self.tableView reloadData];
    
    // 如果返回的数组 count < 10，加载此最后一份数据后，变为没有更多数据的状态
    // [self.tableView.mj_footer endRefreshingWithNoMoreData];
    

} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [self.tableView.mj_header endRefreshing];
    DDLogError(@"GET URL_1_6_3_2 request error:\n%@", error.localizedDescription);
}];
 
*/
