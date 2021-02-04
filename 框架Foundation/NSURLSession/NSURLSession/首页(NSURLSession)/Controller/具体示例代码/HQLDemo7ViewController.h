//
//  HQLDemo7ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 示例：获取新闻列表
 */
@interface HQLDemo7ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 NSURLRequest 的 requestWithURL:cachePolicy:timeoutInterval: 方法
 
 NSURLRequestCachePolicy 无论使用哪种缓存策略，都会在本地缓存数据。
 
 typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
 {
     // 默认的缓存策略，使用协议的缓存策略
     NSURLRequestUseProtocolCachePolicy = 0,
 
     // 忽略本地缓存，每次都从网络加载
     NSURLRequestReloadIgnoringLocalCacheData = 1,
    
     // 忽略本地和远程的缓存数据
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4,
     
     // 忽略本地缓存，每次都从网络加载
     NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,

     // 返回缓存否则加载，很少使用
     NSURLRequestReturnCacheDataElseLoad = 2,
     
     // 只返回缓存，没有也不加载，很少使用
     NSURLRequestReturnCacheDataDontLoad = 3,

     // 重新加载重新验证缓存数据
     NSURLRequestReloadRevalidatingCacheData = 5,
 };
 
 
 */
