//
//  GCDViewController.m
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import "GCDViewController.h"

// Framework
#import <MBProgressHUD.h>

static NSOperationQueue *queue;

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator.hidden = YES;
}

/**
 用 NSInvocationOperation 建了一个后台线程，并且放到 NSOperationQueue 中。
 后台线程执行 download 方法
 
 NSOperation 实现多线程的步骤：
 1. 创建任务：先将需要执行的操作封装到NSOperation对象中。
 2. 创建队列：创建NSOperationQueue。
 3. 将任务加入到队列中：将NSOperation对象添加到NSOperationQueue中。
 */
- (IBAction)someClick:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    queue = [[NSOperationQueue alloc] init]; // 创建其他队列
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    [queue addOperation:op];
}

/**
 download 方法处理下载网页的逻辑。
 下载完成后用 performSelectorOnMainThread 执行 download_completed 方法。
 */
- (void)download {
    NSURL *url = [NSURL URLWithString:@"https://www.youdao.com/"];
    NSError *error;
    NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (data) {
        [self performSelectorOnMainThread:@selector(downloadCompleted:) withObject:data waitUntilDone:NO];
    } else {
        NSLog(@"error when download:%@",error);
    }
}

/**
 downloadCompleted 进行 clear up 的工作，并把下载的内容显示到文本控件中。
 */
- (void)downloadCompleted:(NSString *)data {
    NSLog(@"call back");
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.contentLabel1.text = data;
}

// MARK: 使用 GCD 实现以上三个步骤
- (IBAction)someClick2:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://www.youdao.com/"];
        NSError *error;
        NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                self.contentLabel2.text = data;
            });
            
        } else {
            NSLog(@"error when download:%@",error);
        }
    });
}

@end
