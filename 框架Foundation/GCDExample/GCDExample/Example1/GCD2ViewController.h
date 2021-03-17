//
//  GCD2ViewController.h
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCD2ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 GCD 的特点
 
 1. GCD 会自动利用更多的 CPU 内核
 2. GCD 自动管理线程的生命周期（创建线程，调度任务，销毁线程等）
 3. 程序员只需要告诉 GCD 想要如何执行什么任务，不需要编写任何线程管理代码
 
 */
