//
//  HQLSecondViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLSecondViewController.h"
#import "CustomViewController.h"

@interface HQLSecondViewController ()

@end

@implementation HQLSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)presentCustomViewController:(id)sender {
    CustomViewController *viewController = [[CustomViewController alloc] init];
    
    // !!!: animated 值必须为 NO，因为在 CustomViewController 内部自定义实现了一套动画
    [self  presentViewController:viewController animated:NO completion:nil];
}


@end
