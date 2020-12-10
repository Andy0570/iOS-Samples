//
//  HQLoginViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import "HQLoginViewController.h"

// Framework
#import <SAMKeychain.h>
#import <MBProgressHUD.h>
#import <JKCategories.h>

// View
#import "RMIOLoginView.h"

// Manager
#import "UUIDManager.h"

@interface HQLoginViewController ()

@end

@implementation HQLoginViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self addLoginView];
    
    // 获取设备 UUID
    NSString *uuid = [UUIDManager getKeychainUUID];
    NSLog(@"当前设备 UUID：%@", uuid);
    
    // 通过 SAMKeychain 从钥匙串中获取该应用下的所有账户
    NSString *appBundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSArray *accounts = [SAMKeychain accountsForService:appBundleID];
    NSLog(@"accounts:\n%@", accounts);
    
    // 通过 account key 获取到密码的 SHA 256 哈希值
    NSString *accountKey = [accounts.firstObject objectForKey:kSAMKeychainAccountKey];
    NSString *password = [SAMKeychain passwordForService:appBundleID account:accountKey];
    NSLog(@"sha256:%@",password);
}

- (void)addLoginView {
    // 加载猫头鹰登录视图
    RMIOLoginView *loginView = [[RMIOLoginView alloc] initWithLoginButtonClickedHandle:^(NSString *username, NSString *password) {
        NSLog(@"username = %@,password = %@",username,password);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 模拟网络请求
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            // 3. 通过 SAMKeychain 保存用户名和密码到钥匙串
            // 将用户名和密码通过 SAMKeyChain 保存到钥匙串，密码使用 SHA256 哈希算法加密保存
            NSString *appBundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
            [SAMKeychain setPassword:password.jk_sha256String
                          forService: appBundleID
                             account:username];
        });
    }];
    loginView.frame = self.view.bounds;
    [self.view addSubview:loginView];
}

@end
