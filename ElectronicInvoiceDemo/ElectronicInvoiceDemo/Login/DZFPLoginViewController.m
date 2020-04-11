//
//  DZFPLoginViewController.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/1/19.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "DZFPLoginViewController.h"

// Framework
#import <MBProgressHUD.h>
#import <ChameleonFramework/Chameleon.h>
#import <YYKit.h>

// View
#import "RMIOLoginView.h"

@interface DZFPLoginViewController ()

@property (nonatomic, strong) RMIOLoginView *loginView;

@end

@implementation DZFPLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加登录视图
    [self.view addSubview:self.loginView];
    
    [self setStatusBarStyle:UIStatusBarStyleContrast];
    self.navigationController.hidesNavigationBarHairline = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (RMIOLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[RMIOLoginView alloc] initWithLoginButtonClickedHandle:^(NSString *username, NSString *password) {
            // 点击「登录」按钮后调用...
            // 正则表达式验证输入内容...
            // 密文传输：输入密码转换为 MD5 后再上传到服务器进行验证...
            
            
            // 显示 MBProgressHUD 加载视图...
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.loginView animated:YES];
            hud.label.text = @"正在登录中...";
            
            // 使用 GCD 模拟登录流程，3s 后显示登录成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                // 显示 Alert 弹窗
                // 1.创建弹窗视图控制器对象：UIAlertController
                NSString *message = [NSString stringWithFormat:@"您的账号：%@ 已成功登录！",username];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录成功" message:message preferredStyle:UIAlertControllerStyleAlert];
                // 2.创建按钮对象：UIAlertAction
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 点击弹窗上的「确定」按钮后调用
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                // 3.将按钮添加到弹窗上
                [alertController addAction:action];
                // 4.显示 Alert 弹窗
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }];
        
        // 设置 登录视图的 Frame
        if (@available(iOS 11.0, *)) {
            _loginView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
        }else {
            _loginView.frame = self.view.bounds;
        }
        
    }
    return _loginView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%s",__func__);
}

// 导航栏关闭按钮点击事件
- (IBAction)leftBarButtonDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
