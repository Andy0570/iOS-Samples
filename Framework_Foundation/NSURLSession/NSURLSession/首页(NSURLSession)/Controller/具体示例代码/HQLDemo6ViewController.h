//
//  HQLDemo6ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 NSURLSessionDataTask 设置代理发送请求
 
 之前的请求获得的数据是直接在 `completionHandler:` Block 块中处理的。
 你也可以通过遵守 Delegate 代理的方式获得返回的数据。
 
 💡💡💡 通过代理的方式可以实现一对一的网络请求监控！！！
 
 *********
 使用 NSURLSession 对象时，如果设置了代理，那么 session 会对代理对象保持一个强引用，在合适的时候应该主动进行释放。
 
 可以在控制器调用 viewDidDisappear 方法的时候来进行处理，
 可以通过调用 invalidateAndCancel 方法或者是 finishTasksAndInvalidate 方法来释放对代理对象的强引用

 1. invalidateAndCancel 方法直接取消请求然后释放代理对象
 2. finishTasksAndInvalidate 方法等请求完成之后释放代理对象。

 - (void)viewDidDisappear {
     [super viewDidDisappear];
     
     [self.session invalidateAndCancel];
 }
 
 
 *********
 
 */
@interface HQLDemo6ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
