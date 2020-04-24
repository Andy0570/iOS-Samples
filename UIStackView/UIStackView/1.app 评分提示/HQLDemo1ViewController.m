//
//  HQLDemo1ViewController.m
//  UIStackView
//
//  Created by Qilin Hu on 2020/4/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo1ViewController.h"

@interface HQLDemo1ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *horizontalStackView;

@end

@implementation HQLDemo1ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - IBActions

// 点击按钮，添加一颗星星
- (IBAction)addStar:(id)sender {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // MARK: 通过调用 addArrangedSubview: 方法为 Stack View 添加并管理子视图
    [self.horizontalStackView addArrangedSubview:imageView];
    [UIView animateWithDuration:0.25 animations:^{
        /**
         由于 Stack View 自动为我们管理 Auto Layout constraints，
         我们只能调用 layoutIfNeeded 来实现动画。
         */
        [self.horizontalStackView layoutIfNeeded];
    }];
    
}

// 点击按钮，移除一颗星星
- (IBAction)removeStar:(id)sender {
    UIView *view = self.horizontalStackView.arrangedSubviews.lastObject;
    if (view) {
        // !!!: 调用 removeArrangedSubview: 只是告诉 Stack View 不再需要管理 subview 的约束。而 subview 会一直保持在视图层级结构中直到调用 removeFromSuperview 把它移除。
        [self.horizontalStackView removeArrangedSubview:view];
        // !!!: 调用 removeFromSuperview 是把 subview 从视图层级中移除
        [view removeFromSuperview];
        [UIView animateWithDuration:0.25 animations:^{
            [self.horizontalStackView layoutIfNeeded];
        }];
    }
}


@end
