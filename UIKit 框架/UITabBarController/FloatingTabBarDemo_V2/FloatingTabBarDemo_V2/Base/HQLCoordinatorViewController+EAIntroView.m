//
//  HQLCoordinatorViewController+EAIntroView.m
//  FloatingTabBarDemo_V2
//
//  Created by Qilin Hu on 2020/9/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController+EAIntroView.h"

// Frameworks
#import <EAIntroView.h>

static NSString * const kUserHasShowIntroViewKey = @"user_has_introView";

@interface HQLCoordinatorViewController () <EAIntroDelegate>

@end

@implementation HQLCoordinatorViewController (EAIntroView)

- (void)hql_showIntroWithCrossDissolve {
    // 通过偏好设置查询启动引导页是否已经显示过
    BOOL hasShowIntroView = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasShowIntroViewKey];
    if (hasShowIntroView) return;
    
    // 仅在应用首次下载时，显示启动引导页
    [self showIntroWithCrossDissolve];
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"IntroView_01"];
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"IntroView_02"];
    page2.showTitleView = NO;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"IntroView_03"];
    page3.showTitleView = NO;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"IntroView_04"];
    page4.showTitleView = NO;
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:@"IntroView_05"];
    page5.showTitleView = NO;
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                                       andPages:@[page1, page2, page3, page4, page5]];
    introView.tapToNext = YES;
    introView.delegate = self;
    
    // 添加立即体验按钮，120*40
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(0, 0, 130, 40);
    skipButton.layer.cornerRadius = 15;
    skipButton.layer.borderWidth = 1.0f;
    skipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    // 设置标题
    [skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    // 将自定义按钮添加到 EAIntroView 实例对象
    introView.skipButton = skipButton;
    introView.skipButtonAlignment = EAViewAlignmentCenter;
    introView.skipButtonY = 150.f;
    introView.skipButton.alpha = 0.f;
    introView.skipButton.enabled = NO;
    page5.onPageDidAppear = ^{
        introView.skipButton.enabled = YES;
        [UIView animateWithDuration:0.3f animations:^{
            introView.skipButton.alpha = 1.f;
        }];
    };
    [introView showInView:self.view];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasShowIntroViewKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
