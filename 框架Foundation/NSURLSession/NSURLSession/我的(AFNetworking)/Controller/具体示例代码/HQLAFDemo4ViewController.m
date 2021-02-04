//
//  HQLAFDemo4ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAFDemo4ViewController.h"
#import <AFNetworking.h>

@interface HQLAFDemo4ViewController ()

@end

@implementation HQLAFDemo4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 监听网络变化
- (void)setReachabilityStatusChangeBlock {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*
    AFNetworkReachabilityStatusUnknown          = -1, 未知
    AFNetworkReachabilityStatusNotReachable     = 0,  没有网络
    AFNetworkReachabilityStatusReachableViaWWAN = 1,  蜂窝流量
    AFNetworkReachabilityStatusReachableViaWiFi = 2,  无线
    */
    // 监听网络状态的变化
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线");
                break;
                
            default:
                break;
        }
    }];
    // 开启
    [manager startMonitoring];
}

// 发送 HTTPS 请求
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"--didReceiveChallenge--%@",challenge.protectionSpace);
    /*
     NSURLSessionAuthChallengeUseCredential = 0,      使用
     NSURLSessionAuthChallengePerformDefaultHandling = 1,   忽略(默认)
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,忽略(会取消请求)
     NSURLSessionAuthChallengeRejectProtectionSpace = 3, 忽略(下次继续询问)
     */
    // NSURLAuthenticationMethodServerTrust 服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // 创建证书
        NSURLCredential *credentoal = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credentoal);
    }
}

@end
