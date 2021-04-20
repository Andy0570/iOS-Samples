//
//  HQLBaseViewController.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseViewController.h"

// Framework
#import <YYKit.h>
#import <Chameleon.h>
#import <Masonry.h>

@implementation HQLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *randomColor = [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    self.view.backgroundColor = randomColor;
    
    [self addTestButton];
}

#pragma mark - Private

- (void)addTestButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    // 默认标题
    NSDictionary *normalAttributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:HexColor(@"#108EE9")
        };
    NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"导航到下一个页面" attributes:normalAttributes];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];

    // 高亮标题
    NSDictionary *highLightedAttributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[UIColor whiteColor]
        };
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"导航到下一个页面" attributes:highLightedAttributes];
    [button setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];

    // 高亮背景颜色
    [button setBackgroundImage:[UIImage imageWithColor:HexColor(@"#108EE9")]
                      forState:UIControlStateHighlighted];

    // 圆角和边框
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [HexColor(@"#108EE9") CGColor];

    // Target-Action
    [button addTarget:self
               action:@selector(buttonClickUpHandler:)
     forControlEvents:UIControlEventTouchUpInside];

    // 将按钮添加到视图上
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 150, 60);
    button.center = self.view.center;
}

#pragma mark - Actions

// 导航到下一个视图控制器页面
- (void)buttonClickUpHandler:(id)sender {
    HQLBaseViewController *baseViewController = [[HQLBaseViewController alloc] init];
    [self.navigationController pushViewController:baseViewController animated:YES];
}


#pragma mark - <JXCategoryListContentViewDelegate>

- (UIView *)listView {
    return self.view;
}

/**
 可选实现，列表将要显示的时候调用
 */
- (void)listWillAppear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表将要消失的时候调用
 */
- (void)listWillDisappear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

@end
