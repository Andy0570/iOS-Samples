//
//  HQLFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLFirstViewController.h"

#import "HQLDatePickerPresentationController.h"
#import "CustomDatePickerViewController.h"


@interface HQLFirstViewController ()

@end

@implementation HQLFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)presentDatePickerController:(id)sender {
    // 自定义日期选择器
    CustomDatePickerViewController *datePicker = [[CustomDatePickerViewController alloc] init];
    
    // 呈现视图控制器
    // UIPresentationController 子类，描述转场动画、自定义日期选择器 frame
    HQLDatePickerPresentationController *presentationController = [[HQLDatePickerPresentationController alloc] initWithPresentedViewController:datePicker presentingViewController:self];
    
    // 指定 Presented View Controller 的 UIViewControllerTransitioningDelegate 协议由哪个类来实现
    datePicker.transitioningDelegate = presentationController;
    
    // animated 必须是YES，因为此 datePicker 没有自己实现动画细节协议。
    [self presentViewController:datePicker animated:YES completion:nil];
}

@end
