//
//  DZFPQueryViewController.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/3/22.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "DZFPQueryViewController.h"

@interface DZFPQueryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DZFPQueryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"发票查验";
    
    // !!!:在该页面单独设置主题色
    /**
     页面元素 flatRedColor
     UIContentStyleContrast - 不会改变导航栏的字体和颜色，导航栏返回按钮白色、字体黑色
     UIContentStyleLight - 返回按钮白色、返回字体黑色！！！
     UIContentStyleDark - 不会改变导航栏的字体和颜色，导航栏返回按钮黑色、字体黑色
     */
//    [self setThemeUsingPrimaryColor:[UIColor flatRedColor]
//                   withContentStyle:UIContentStyleDark];
    
    /**
     UIContentStyleContrast - 不会改变导航栏的字体和颜色，导航栏返回按钮白色、字体黑色
     UIContentStyleDark - 导航栏不变，页面元素 flatMintColor
     */
//    [self setThemeUsingPrimaryColor:[UIColor flatOrangeColor]
//                 withSecondaryColor:[UIColor flatMintColor]
//                    andContentStyle:UIContentStyleContrast];
    
    /**
     页面元素 flatBlueColor
     
     UIContentStyleDark - 导航栏及状态栏 绿底黑字
     */
//    [self setThemeUsingPrimaryColor:[UIColor flatBlueColor]
//                    withContentStyle:UIContentStyleDark];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setThemeUsingPrimaryColor:[UIColor flatBlueColor]
                    withContentStyle:UIContentStyleDark];
    
    // !!!: 测试修改状态栏颜色
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    // [self setStatusBarStyle:UIStatusBarStyleDarkContent];
    // 🎉 使用了导航栏
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // 白色内容
    
    // !!!: 测试修改导航栏颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setThemeUsingPrimaryColor:HexColor(@"#47c1b6")
                 withSecondaryColor:[UIColor clearColor]
                    andContentStyle:UIContentStyleContrast];
    
    // !!!: 测试修改状态栏颜色
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // [self setStatusBarStyle:UIStatusBarStyleDarkContent];
    // 🎉 使用了导航栏
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault; // 黑色内容
    
    // !!!: 测试修改导航栏颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private



#pragma mark - IBActions

// 点击「查询」按钮，触发该方法
- (IBAction)queryButtonDidClicked:(id)sender {
    
    // ---- 1. 正则表达式判断输入内容格式；
    
    
    
    // ---- 2. 封装上传模型数据；
    
    
    
    // ---- 3. 发起网络请求，连接服务器；
    
    
}


@end
