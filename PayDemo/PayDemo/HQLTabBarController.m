//
//  HQLTabBarController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/8/2.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLTabBarController.h"

// Framework
#import <EAIntroView.h>

@interface HQLTabBarController () <EAIntroDelegate>

@end

@implementation HQLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载引导视图
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"IntroView_01"];
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"IntroView_02"];
    page2.showTitleView = NO;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"IntroView_03"];
    page3.showTitleView = NO;
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[[UIScreen mainScreen] bounds] andPages:@[page1, page2, page3]];
    introView.tapToNext = YES;
    introView.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 170, 45);
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    introView.skipButton = button;
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
    // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasShowIntroViewKey];
}

@end
