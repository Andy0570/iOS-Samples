//
//  WrongPasswordViewController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "WrongPasswordViewController.h"

// Frameworks
#import <POP.h>

@interface WrongPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation WrongPasswordViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Actions

// 为输入框添加晃动动画，示意“密码输入错误”
- (IBAction)login:(id)sender {
    // 以 X 轴方向执行动画
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shake.springBounciness = 20;
    shake.velocity = @(3000);
    [self.passwordTextField.layer pop_addAnimation:shake forKey:@"shakePassword"];
}

@end


/**
 - (void)animateBackgroundColorCell:(UITableViewCell *)cell {
     cell.backgroundColor = [UIColor orangeColor];
     [UIView animateWithDuration:0.3 animations:^{
         cell.backgroundColor = [UIColor whiteColor];
     }];
 }
 */
