//
//  GCD2ViewController.m
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import "GCD2ViewController.h"

// Framework
#import <MBProgressHUD.h>
#import <SDWebImage.h>

@interface GCD2ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GCD2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 MARK: 知识点
 串行队列：线程只能依次有序的执行。
 并发队列：线程可以同时一起进行执行。实际上是 CPU 在多条线程之间快速的切换。（并发功能只有在异步（dispatch_async）函数下才有效）

 同步：一个接着一个，前一个没有执行完，后面不能执行，不开线程。
 异步：开启多个新线程，任务同一时间可以一起执行。异步是多线程的代名词
 */

/**
  MARK: 串行同步
  按序执行任务，不开启新线程（都在主线程运行）。

  串行同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
  串行同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
 */
- (IBAction)syncSerialAction:(id)sender {
    // 自定义串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.serial", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行多个任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步任务3:%@", [NSThread currentThread]);
        }
    });
}

/**
  MARK: 串行异步
  异步任务会开启新线程，但因为是串行任务，所以还是按序执行。

  串行异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务2:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务2:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务2:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务3:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务3:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  串行异步任务3:<NSThread: 0x282cb8800>{number = 8, name = (null)}
 */
- (IBAction)asyncSerialAction:(id)sender {
    // 自定义串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.serial", DISPATCH_QUEUE_SERIAL);
    
    // 异步执行多个任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步任务3:%@", [NSThread currentThread]);
        }
    });
}

/**
  MARK: 并发同步
  因为是同步的，所以执行完一个任务，再执行下一个任务。不会开启新线程。

  并发同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务1:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务2:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
  并发同步任务3:<NSThread: 0x282cec180>{number = 1, name = main}
 */
- (IBAction)syncConcurrentAction:(id)sender {
    // 自定义并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行多个任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步任务3:%@", [NSThread currentThread]);
        }
    });
}

/**
  MARK: 并发异步
  任务交替执行，开启多线程。

  并发异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  并发异步任务2:<NSThread: 0x282cb92c0>{number = 9, name = (null)}
  并发异步任务3:<NSThread: 0x282ca46c0>{number = 10, name = (null)}
  并发异步任务2:<NSThread: 0x282cb92c0>{number = 9, name = (null)}
  并发异步任务3:<NSThread: 0x282ca46c0>{number = 10, name = (null)}
  并发异步任务2:<NSThread: 0x282cb92c0>{number = 9, name = (null)}
  并发异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
  并发异步任务3:<NSThread: 0x282ca46c0>{number = 10, name = (null)}
  并发异步任务1:<NSThread: 0x282cb8800>{number = 8, name = (null)}
 */
- (IBAction)asyncConcurrentAction:(id)sender {
    // 自定义并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行多个任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步任务3:%@", [NSThread currentThread]);
        }
    });
}

/**
 !!!: 主队列同步
 如果在主线程中运用这种方式，则会发生死锁，程序崩溃。
 
 主队列同步造成死锁的原因：
 如果在主线程中运用主队列同步，也就是把任务放到了主线程的队列中。
 而同步对于任务是立刻执行的，那么当把第一个任务放进主队列时，它就会立马执行。
 可是主线程现在正在处理 syncMain 方法，任务需要等 syncMain 执行完才能执行。
 syncMain 执行到第一个任务的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
 这样 syncMain 方法和第一个任务就开始了互相等待，形成了死锁。
 */
- (IBAction)syncMainAction:(id)sender {
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 同步执行多个任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步任务3:%@", [NSThread currentThread]);
        }
    });
}

/**
 MARK: 主队列异步
 在主线程中任务按顺序执行。
 
 主队列异步任务1:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务1:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务1:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务2:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务2:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务2:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务3:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务3:<NSThread: 0x283354180>{number = 1, name = main}
 主队列异步任务3:<NSThread: 0x283354180>{number = 1, name = main}
 */
- (IBAction)asyncMainAction:(id)sender {
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 异步执行多个任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步任务2:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步任务3:%@", [NSThread currentThread]);
        }
    });
}

// MARK: GCD 线程切换
- (IBAction)communicationBetweenThreadAction:(id)sender {
    // 在视图上显示 HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // 异步后台线程执行，使 UIKit 有机会重新绘制 HUD，并添加到视图层次结构中
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Do something useful in the background
        NSURL *url = [NSURL URLWithString:@"https://static01.imgkr.com/temp/854a8bf559d94787a2b6bf81fe30f97d.jpg"];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageHighPriority progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (image) {
                // 主线程执行，请确保始终在主线程上更新 UI（包括 MBProgressHUD）
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    self.imageView.image = image;
                });
            }
            
        }];
        
    });
}


// MARK: GCD 队列组
/**
 异步执行几个耗时操作，当这几个操作都完成之后再回到主线程进行操作，就可以用到队列组了。
 
 特点：
 所有的任务会并发的执行 (不按序)。
 所有的异步函数都添加到队列中，然后再纳入队列组的监听范围。
 使用 dispatch_group_notify 函数，来监听上面的任务是否完成，如果完成，就会调用这个方法。
 
 
 队列组1：有一个耗时操作完成！
 队列组2：有一个耗时操作完成！
 队列组：前面的耗时操作都完成了，回到主线程进行相关操作
 */
- (IBAction)groupAction:(id)sender {
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组1：有一个耗时操作完成！");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组2：有一个耗时操作完成！");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"队列组：前面的耗时操作都完成了，回到主线程进行相关操作");
    });
}

/**
 MARK: GCD 快速迭代
 dispatch_apply 可以同时遍历多个数字。
 
 2021-03-17 18:34:12.141196+0800 GCDExample[53751:4616806] dispatch_apply:0====<NSThread: 0x2833144c0>{number = 8, name = (null)}
 2021-03-17 18:34:12.141201+0800 GCDExample[53751:4613164] dispatch_apply:1====<NSThread: 0x283354180>{number = 1, name = main}
 2021-03-17 18:34:12.141643+0800 GCDExample[53751:4616806] dispatch_apply:3====<NSThread: 0x2833144c0>{number = 8, name = (null)}
 2021-03-17 18:34:12.141647+0800 GCDExample[53751:4613164] dispatch_apply:2====<NSThread: 0x283354180>{number = 1, name = main}
 2021-03-17 18:34:12.142009+0800 GCDExample[53751:4616806] dispatch_apply:4====<NSThread: 0x2833144c0>{number = 8, name = (null)}
 2021-03-17 18:34:12.142076+0800 GCDExample[53751:4613164] dispatch_apply:5====<NSThread: 0x283354180>{number = 1, name = main}
 2021-03-17 18:34:12.142347+0800 GCDExample[53751:4616806] dispatch_apply:6====<NSThread: 0x2833144c0>{number = 8, name = (null)}
 */
- (IBAction)applyAction:(id)sender {
    // 自定义并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // dispatch_apply 几乎同时遍历多个数字
    dispatch_apply(7, queue, ^(size_t index) {
        NSLog(@"dispatch_apply:%zd====%@",index, [NSThread currentThread]);
    });
}

/**
 MARK: GCD 栅栏
 
 当任务需要异步进行，但是这些任务需要分成两组来执行，第一组完成之后才能进行第二组的操作。
 这时候就用了到 GCD 的栅栏方法 dispatch_barrier_async。
 
 GCD 栅栏，并发异步任务2:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 GCD 栅栏，并发异步任务1:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 GCD 栅栏，并发异步任务2:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 GCD 栅栏，并发异步任务1:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 GCD 栅栏，并发异步任务2:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 GCD 栅栏，并发异步任务1:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 -------- barrier -------- <NSThread: 0x283305cc0>{number = 11, name = (null)}
 ***** 并发异步执行，但是34一定是在12后面
 GCD 栅栏，并发异步任务3:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 GCD 栅栏，并发异步任务4:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 GCD 栅栏，并发异步任务3:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 GCD 栅栏，并发异步任务4:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 GCD 栅栏，并发异步任务3:<NSThread: 0x283305cc0>{number = 11, name = (null)}
 GCD 栅栏，并发异步任务4:<NSThread: 0x28331ea00>{number = 12, name = (null)}
 */
- (IBAction)barrierAction:(id)sender {
    NSLog(@"\n++++++GCD 栅栏++++++\n");
    
    // 自定义并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.company.project.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"GCD 栅栏，并发异步任务1:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"GCD 栅栏，并发异步任务2:%@", [NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"-------- barrier -------- %@", [NSThread currentThread]);
        NSLog(@"***** 并发异步执行，但是34一定是在12后面");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"GCD 栅栏，并发异步任务3:%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"GCD 栅栏，并发异步任务4:%@", [NSThread currentThread]);
        }
    });
}

// 隐藏图片
- (IBAction)hideImage:(id)sender {
    self.imageView.image = nil;
}


@end
