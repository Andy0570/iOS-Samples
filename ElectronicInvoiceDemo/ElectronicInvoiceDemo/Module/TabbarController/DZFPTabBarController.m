//
//  DZFPTabBarController.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "DZFPTabBarController.h"

// Frameworks
#import <EAIntroView.h>

static NSString *const KUserHasShowIntroViewKey = @"user_has_introView";

@interface DZFPTabBarController () <EAIntroDelegate>

@end

@implementation DZFPTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 加载启动引导页
    BOOL hasShowIntroView = [[NSUserDefaults standardUserDefaults] boolForKey:KUserHasShowIntroViewKey];
    if (hasShowIntroView) return;
    
    // 仅在应用首次下载时，显示启动引导页
    [self showIntroWithCrossDissolve];
}

#pragma mark - Private

// 显示引导页
- (void)showIntroWithCrossDissolve {
    
    // 引导页1
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"photo_1"];
    page1.showTitleView = NO;
    
    // 引导页2
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"photo_2"];
    page2.showTitleView = NO;
    
    // 引导页3
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"photo_3"];
    page3.showTitleView = NO;
    
    // 引导页4
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"photo_4"];
    page4.showTitleView = NO;
    
    // 引导页容器视图
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[[UIScreen mainScreen] bounds] andPages:@[page1, page2, page3, page4]];
    introView.tapToNext = YES;
    introView.delegate = self;
    
    // 引导页按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 170, 45);
//    [button setTitle:@"立即体验" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.layer.cornerRadius = 15;
//    button.layer.borderWidth = 1.0f;
//    button.layer.borderColor = [[UIColor whiteColor] CGColor];
//    introView.skipButton = button;
//    introView.skipButtonAlignment = EAViewAlignmentCenter;
//    introView.skipButtonY = 150.f;
//    introView.skipButton.alpha = 0.f;  // 默认透明
//    introView.skipButton.enabled = NO; // 默认按钮禁用
//    page4.onPageDidAppear = ^{
//        introView.skipButton.enabled = YES; // 启用按钮
//        // 最后一页出现时，动画显示按钮
//        [UIView animateWithDuration:0.3f animations:^{
//            introView.skipButton.alpha = 1.f;
//        }];
//    };
    
    [introView showInView:self.view];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    
    // 应用首次启动时，才会显示引导页。
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasShowIntroViewKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
