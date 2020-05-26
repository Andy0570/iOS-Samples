//
//  HQLoginViewController.m
//  KeychainDemo
//
//  Created by Qilin Hu on 2020/5/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLoginViewController.h"

// Frameworks
#import <SAMKeychain.h>
#import <MBProgressHUD.h>
#import <YYKit.h>

// Views
#import "RMIOLoginView.h"

// Others
#import "UUIDManager.h"



@interface HQLoginViewController ()

@end

@implementation HQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self addLoginView];
    
    // 获取设备 UUID
    NSString *deviceId = [UUIDManager getKeychainUUID];
    NSLog(@"当前设备 UUID：%@", deviceId);
    // 首次安装，当前设备 UUID：C7798562-6537-4CB4-BB25-69713015078D
    // 删除应用，当前设备 UUID：C7798562-6537-4CB4-BB25-69713015078D
    // 删除应用，当前设备 UUID：C7798562-6537-4CB4-BB25-69713015078D
    
    // 通过 SAMKeyChain 从钥匙串中获取该应用下的所有账户
    NSArray *accountArray = [SAMKeychain accountsForService:[UIApplication sharedApplication].appBundleID];
    NSLog(@"accountArray:%@",accountArray);

    // 通过 account key 获取到密码
    NSString *password = [SAMKeychain passwordForService:[UIApplication sharedApplication].appBundleID account:[accountArray.firstObject objectForKey:kSAMKeychainAccountKey]];
    NSLog(@"password=%@",password);
}

- (void)addLoginView {
    // 加载猫头鹰登录视图
    RMIOLoginView *loginView = [[RMIOLoginView alloc] initWithLoginButtonClickedHandle:^(NSString *username, NSString *password) {
        NSLog(@"username = %@,password = %@",username,password);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 模拟网络请求
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            // 将用户名和密码通过 SAMKeyChain 保存到钥匙串，密码使用 SHA256 哈希算法加密保存
            [SAMKeychain setPassword:[password sha256String]
                          forService:[UIApplication sharedApplication].appBundleID
                             account:username];
        });
    }];
    loginView.frame = self.view.bounds;
    [self.view addSubview:loginView];
}

@end
