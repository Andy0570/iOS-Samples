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
