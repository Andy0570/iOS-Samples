//
//  ButtonTemplate01ViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/12/3.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 在页面底部添加一个按钮
@interface ButtonTemplate01ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END



/**
 
 // 在 Web 页面底部添加按钮，高 50
 - (void)addConfirmButton {
     // 按钮的容器视图
     UIView *contaienrView = [[UIView alloc] init];
     [self.view addSubview:contaienrView];
     [contaienrView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.webView.mas_bottom);
         make.left.and.right.equalTo(self.view);
         if (@available(iOS 11.0, *)) {
             make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
         } else {
             // Fallback on earlier versions
             make.bottom.equalTo(self.view.mas_bottom);
         }
     }];
     
     // 按钮
     [contaienrView addSubview:self.confirmButton];
     [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(contaienrView.mas_top).with.offset(10);
         make.left.equalTo(contaienrView).with.offset(24);
         make.right.equalTo(contaienrView).with.offset(-24);
         make.bottom.equalTo(contaienrView.mas_bottom).with.offset(-10);
     }];
 }
 
 */
