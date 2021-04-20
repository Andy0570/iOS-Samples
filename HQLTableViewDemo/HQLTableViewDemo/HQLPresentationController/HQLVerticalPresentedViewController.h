//
//  HQLVerticalPresentedViewController.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLVerticalPresentedViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


/**
 使用示例：
 
 // 1.初始化 HQLPresentationViewController 或其子类实例
 HQLVerticalPresentedViewController *vc = [[HQLVerticalPresentedViewController alloc] initWithFrame:rect];
 vc.view.backgroundColor = [UIColor whiteColor];
 
 // 2.初始化 HQLPresentationController 实例
 HQLVerticalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
 
 // 3.设置 UIViewControllerTransitioningDelegate
 presentationController = [[HQLVerticalPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
 
 // 4.模态呈现
 vc.transitioningDelegate = presentationController;
 [self presentViewController:vc animated:YES completion:NULL];
*/
