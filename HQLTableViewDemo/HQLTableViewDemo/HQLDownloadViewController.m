//
//  HQLDownloadViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/11.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLDownloadViewController.h"
#import "AppDelegate.h"

@interface HQLDownloadViewController () <NSURLSessionDownloadDelegate>


// 进程内会话，用于创建「可撤销任务」、「可恢复任务」
@property (nonatomic, strong) NSURLSession *inProcessSession;
// 后台会话，用于创建「后台任务」
@property (nonatomic, strong, readonly) NSURLSession *backgroundSession;


// 可取消任务
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *cancellableTask;
// 可恢复任务
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *resumableTask;
// 后台任务
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *backgroundTask;

// 后台下载临时数据
@property (nonatomic, strong, readwrite) NSData *partialDownload;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;
// 关联的按钮集合，包括「可撤销任务」、「可恢复任务」、「后台任务」
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *startButtons;


@end

@implementation HQLDownloadViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从 nib 文件加载视图后，处理额外的初始化工作
    self.progressIndicator.hidden = YES;
    self.progressIndicator.progress = 0;
    
    // Make sure that we've attached to the background session
    self.backgroundSession.sessionDescription = @"Background session";
}

#pragma mark - Custom Accessors

// 后台会话，单例类
- (NSURLSession *)backgroundSession {
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.shinobicontrols.BackgroundDownload.BackgroundSession"];
        backgroundSession = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    });
    return backgroundSession;
}

#pragma mark - IBActions

// 开启一个可撤销任务
- (IBAction)startCancellable:(id)sender {
    if (!_cancellableTask) {
        if(!_inProcessSession) {
            // 创建默认会话
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            _inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                             delegate:self
                                                        delegateQueue:nil];
            _inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        // Image CreativeCommons courtesy of flickr.com/charliematters
        NSString *url = @"https://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        // 创建可取消任务
        _cancellableTask = [_inProcessSession downloadTaskWithRequest:request];
        
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
        
        // 开启下载任务
        [_cancellableTask resume];
    }
}

// 开启一个可恢复任务
- (IBAction)startResumable:(id)sender {
    if(!self.resumableTask) {
        if(!_inProcessSession) {
            // 创建默认会话
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            _inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            _inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        if(_partialDownload) {
            // 1. 如果存在缓存数据，继续下载此任务
            self.resumableTask = [_inProcessSession downloadTaskWithResumeData:_partialDownload];
        } else {
            // 2. 如果不存在缓存，新建可恢复任务
            // Image CreativeCommons courtesy of flickr.com/charliematters
            NSString *url = @"https://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            // 创建可恢复任务
            self.resumableTask = [_inProcessSession downloadTaskWithRequest:request];
        }
        
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
        
        // 开启下载任务
        [self.resumableTask resume];
    }
}

// 开始后台任务
- (IBAction)startBackground:(id)sender {
    // Image CreativeCommons courtesy of flickr.com/charliematters
    NSString *url = @"https://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // self.backgroundSession 是单例对象
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    
    [self setDownloadButtonsAsEnabled:NO];
    self.imageView.hidden = YES;
    
    // 开启下载任务
    [self.backgroundTask resume];
}

// 取消任务
- (IBAction)cancelCancellable:(id)sender {
    if(self.cancellableTask) {
        // 1. 可取消任务
        [self.cancellableTask cancel];
        self.cancellableTask = nil;
    } else if(self.resumableTask) {
        // 2. 可恢复任务
        [self.resumableTask cancelByProducingResumeData:^(NSData *resumeData) {
            // ❇️ 缓存已下载数据
            self.partialDownload = resumeData;
            self.resumableTask = nil;
        }];
    } else if(self.backgroundTask) {
        // 3. 后台任务
        [self.backgroundTask cancel];
        self.backgroundTask = nil;
    }
}

#pragma mark - Private

/**
 更新启动任务按钮的状态
 
 当前有三种下载任务：「可撤销任务」、「可恢复任务」、「后台任务」，
 当其中一个按钮被点击后，系统正在执行一个任务时，更新 UI，更新以上所有3个按钮为不可点击状态

 @param enabled 按钮是否可以被点击
 */
- (void)setDownloadButtonsAsEnabled:(BOOL)enabled
{
    // 更新按钮 enable 状态
    for(UIBarButtonItem *btn in self.startButtons) {
        btn.enabled = enabled;
    }
}

#pragma mark - NSURLSessionDownloadDelegate

// 追踪下载任务进度，更新进度条
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    // 主线程更新进度条
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.hidden = NO;
        self.progressIndicator.progress = currentProgress;
    });
}

// 恢复下载后调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Leave this for now
}

// 下载任务成功后调用
// 1.将下载完成的临时文件保存到文档（document）目录中；
// 2.取出文档目录中的图片文件，显示到 UI 上；
// 3.会话置空，解除循环引用；
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // We've successfully finished the download. Let's save the file
    // 保存到文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    NSError *error;
    
    // 首先，确保删除文件中已经存在的任何其他文件
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    
    if (success) {
        // 保存到文件后，更新主线程 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.hidden = NO;
        });
    }else {
        NSLog(@"Couldn't copy the downloaded file");
    }
    
    // ❇️ 下载完成后，会话置空，解除循环引用
    if(downloadTask == self.cancellableTask) {
        self.cancellableTask = nil;
    } else if (downloadTask == self.resumableTask) {
        self.resumableTask = nil;
        self.partialDownload = nil;
    } else if (session == self.backgroundSession) {
        // 后台会话
        self.backgroundTask = nil;
        // Get hold of the app delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.backgroundURLSessionCompletionHandler) {
            // Need to copy the completion handler
            void (^handler)(void) = appDelegate.backgroundURLSessionCompletionHandler;
            appDelegate.backgroundURLSessionCompletionHandler = nil;
            handler();
        }
    }
    
}

#pragma mark - NSURLSessionTaskDelegate

// 每一个任务结束的时候执行-NSURLSessionDelegate,不管任务是不是正常结束:
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 主线程更新 UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.hidden = YES;
        [self setDownloadButtonsAsEnabled:YES];
    });
}

@end
