//
//  ViewController.m
//  HQLPasswordViewDemo
//
//  Created by ToninTech on 2017/6/19.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "ViewController.h"
#import "HQLConst.h"
#import "UIView+Extension.h"
#import "HQLPasswordView.h"

static const CGFloat kRequestTime = 3.0f;
static const CGFloat KDelay = 2.0f;

@interface ViewController ()

@property (nonatomic, strong) HQLPasswordView *passwordView;

@end

@implementation ViewController

static BOOL flag = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)paymentButtonDidClicked:(id)sender {

    self.passwordView = [[HQLPasswordView alloc] init];
    [self.passwordView showInView:self.view.window];
    self.passwordView.title = @"我是标题";
    self.passwordView.loadingText = @"正在支付中...";
    self.passwordView.closeBlock = ^{
        NSLog(@"取消支付回调...");
    };
    self.passwordView.forgetPasswordBlock = ^{
        NSLog(@"忘记密码回调...");
    };
    WS(weakself);
    self.passwordView.finishBlock = ^(NSString *password) {
        NSLog(@"完成支付回调...");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            flag = !flag;
            if (flag) {
                // 购买成功，跳转到成功页
                [weakself.passwordView requestComplete:YES message:@"购买成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( KDelay* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 从父视图移除密码输入视图
                    [weakself.passwordView removePasswordView];
                });
            } else {
                // 购买失败，跳转到失败页
                [weakself.passwordView requestComplete:NO];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 购买失败的处理，也可以继续支付
                    
                });
            }
        });
    };
}

@end
