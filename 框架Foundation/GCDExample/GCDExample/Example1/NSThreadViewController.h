//
//  NSThreadViewController.h
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSThreadViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 MARK: NSThread
 NSThread：面向对象，可直接操作线程对象。线程的生命周期由程序员管理。
 线程是进程的基本执行单元，一个进程对应多个线程。
 
 MARK: 返回当前线程
 [NSThread currentThread];
 // 如果number=1，则表示在主线程，否则是子线程
 打印结果：<NSThread: 0x608000261380>{number = 1, name = main}
 
 MARK: 阻塞休眠
 // 休眠多久
 [NSThread sleepForTimeInterval:2];
 // 休眠到指定时间
 [NSThread sleepUntilDate:[NSDate date]];
 
 MARK: 类方法补充
 // 退出线程
 [NSThread exit];
 // 判断当前线程是否为主线程
 [NSThread isMainThread];
 // 判断当前线程是否是多线程
 [NSThread isMultiThreaded];
 // 主线程的对象
 NSThread *mainThread = [NSThread mainThread];
 
 MARK: NSThread 的一些属性
 //线程是否在执行
 thread.isExecuting;
 //线程是否被取消
 thread.isCancelled;
 //线程是否完成
 thread.isFinished;
 //是否是主线程
 thread.isMainThread;
 //线程的优先级，取值范围0.0到1.0，默认优先级0.5，1.0表示最高优先级，优先级高，CPU调度的频率高
  thread.threadPriority;
 */
