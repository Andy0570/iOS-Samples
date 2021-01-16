//
//  HQLDemo1ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 创建 NSURLSessionDataTask 数据任务
 
 1. 默认会话
 2. 短暂会话
 3. 后台会话
 */
@interface HQLDemo1ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 关于后台会话
 
 如果你创建了一个后台会话，必须使用代理来接收数据！！！
 
 创建后台会话时，一定要赋予一个唯一的 identifier 标识符，如 @"com.myapp.networking.background"，
 这样在 APP 下次运行的时候，能够根据 identifier 来进行相关的区分。
 如果用户关闭了 APP，iOS 系统会关闭所有的 background Session。
 而且，被用户强制关闭了以后，iOS 系统不会主动唤醒 APP，只有用户下次启动了 APP，数据传输才会继续。
 
 */
