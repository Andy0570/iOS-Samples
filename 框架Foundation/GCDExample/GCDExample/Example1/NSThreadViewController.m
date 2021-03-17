//
//  NSThreadViewController.m
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import "NSThreadViewController.h"

@interface NSThreadViewController ()

@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Actions

- (IBAction)createNSThread1:(id)sender {
    // 方法一，需要 start
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:@"NSThread1"];
    // 线程加入线程池等待 CPU 调度，时间很快，几乎是立刻执行
    [thread1 start];
}

- (IBAction)createNSThread2:(id)sender {
    // 方法二：创建完成后自动启动
    [NSThread detachNewThreadSelector:@selector(doSomething2:) toTarget:self withObject:@"NSThread2"];
}

- (IBAction)createNSThread3:(id)sender {
    // 方法三：隐式创建，直接启动
    [self performSelectorInBackground:@selector(doSomething3:) withObject:@"NSThread3"];
}

#pragma mark - Private

- (void)doSomething1:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"doSomething1:%@, 线程：%@",object, [NSThread currentThread]);
}

- (void)doSomething2:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"doSomething2:%@, 线程：%@",object, [NSThread currentThread]);
}

- (void)doSomething3:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"doSomething3:%@, 线程：%@",object, [NSThread currentThread]);
}

@end
