//
//  HQLShowPasswordViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShowPasswordViewController.h"

#import "HQLVerticalPresentationController.h"
#import "HQLPasswordViewController.h"

@interface HQLShowPasswordViewController ()

@end

@implementation HQLShowPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)presentPasswordViewController:(id)sender {
    
    // 1.初始化 HQLPresentationViewController 实例
    HQLPasswordViewController *passwordViewController = [[HQLPasswordViewController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 455)];
    
    // 2.初始化 HQLPresentationController 实例
    HQLVerticalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[HQLVerticalPresentationController alloc] initWithPresentedViewController:passwordViewController presentingViewController:self];
    
    // 3.设置 UIViewControllerTransitioningDelegate
    passwordViewController.transitioningDelegate = presentationController;

    // 4.模态呈现
    [self presentViewController:passwordViewController animated:YES completion:NULL];
}


@end
