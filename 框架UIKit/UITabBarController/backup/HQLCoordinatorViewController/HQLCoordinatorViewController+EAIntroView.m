//
//  HQLCoordinatorViewController+EAIntroView.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/8/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController+EAIntroView.h"
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
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.showTitleView = NO;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.showTitleView = NO;
    
    // 根据系统屏幕尺寸选择图片
    if (IS_NOTCH_SCREEN) {
        page1.bgImage = [UIImage imageNamed:@"IntroView_01_x"];
        page2.bgImage = [UIImage imageNamed:@"IntroView_02_x"];
        page3.bgImage = [UIImage imageNamed:@"IntroView_03_x"];
    } else {
        page1.bgImage = [UIImage imageNamed:@"IntroView_01"];
        page2.bgImage = [UIImage imageNamed:@"IntroView_02"];
        page3.bgImage = [UIImage imageNamed:@"IntroView_03"];
    }
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                                       andPages:@[page1, page2, page3]];
    introView.tapToNext = YES;
    introView.delegate = self;
    
    // 添加立即体验按钮，120*40
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *skipBtnThemeColor = HexColor(@"#A2D56A");
    skipButton.frame = CGRectMake(0, 0, 130, 40);
    skipButton.layer.cornerRadius = 15;
    skipButton.layer.borderWidth = 1.0f;
    skipButton.layer.borderColor = [skipBtnThemeColor CGColor];
    // 设置标题
    [skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [skipButton setTitleColor:skipBtnThemeColor forState:UIControlStateNormal];

    // 将自定义按钮添加到 EAIntroView 实例对象
    introView.skipButton = skipButton;
    introView.skipButtonAlignment = EAViewAlignmentCenter;
    introView.skipButtonY = 150.f;
    introView.skipButton.alpha = 0.f;
    introView.skipButton.enabled = NO;
    page3.onPageDidAppear = ^{
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
