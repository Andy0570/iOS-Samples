### NSURLSessionConfiguration

创建 **NSURLSessionConfiguration** 对象的三种方式：

```objectivec
// 默认会话配置
NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

// 短暂会话配置，无缓存（caches），cookies 和证书（credentials）
NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];

// 后台会话配置
NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.Apple.BackgroundDownload.BackgroundSession"];
```

### NSURLSession

创建 **NSURLSession** 对象的三种方式：

```objectivec
// 1. 单例类会话,便捷创建方法
NSURLSession *sharedSession = [NSURLSession sharedSession];

// 2. sessionWithConfiguration:
// 一般用 Block 处理服务器回调时使用
// 默认会话
NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig];
// 短暂会话
NSURLSession *ephemeralSesson = [NSURLSession sessionWithConfiguration:ephemeralConfig];
// 后台会话
NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfig];

// 3. sessionWithConfiguration:delegate:delegateQueue:
// 需要实现委托协议或者指定线程的创建方法
NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
// 默认会话
NSURLSession *defalutSession1 = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:operationQueue];
// 短暂会话
NSURLSession *ephemeralSesson1 = [NSURLSession sessionWithConfiguration:ephemeralConfig delegate:self delegateQueue:operationQueue];
// 后台会话
NSURLSession *backgroundSession1 = [NSURLSession sessionWithConfiguration:backgroundConfig delegate:self delegateQueue:operationQueue];
```

#### NSURLSessionTask

创建 **NSURLSessionTask** 对象有四种种方式：

1. 数据任务(NSURLSessionDataTask)
2. 上传任务(NSURLSessionUploadTask)
3. 下载任务(NSURLSessionDownloadTask)
4. 流任务（NSURLSessionStreamTask）：WWDC2015新增，提供 TCP/IP 连接接口。

![](http://upload-images.jianshu.io/upload_images/2648731-7c60b3982ce6f2c8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### NSURLSessionDelegate 委托协议

![](http://upload-images.jianshu.io/upload_images/2648731-5845fcbe4e8a35c5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 示例代码

注：该项目的 [源码](https://github.com/ScottLogic/iOS7-day-by-day/blob/master/01-nsurlsession/01-nsurlsession.md)

```objectivec
// *************************************************
// SCViewController.h
#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

@property (strong, nonatomic) NSURLSessionDownloadTask *resumableTask;   // 可恢复任务
@property (strong, nonatomic) NSURLSessionDownloadTask *backgroundTask;  // 后台任务

@property (strong, nonatomic, readonly) NSURLSession *backgroundSession; // 后台会话

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *startButtons;

- (IBAction)startCancellable:(id)sender;  // 开始任务
- (IBAction)cancelCancellable:(id)sender; // 取消任务
- (IBAction)startResumable:(id)sender;    // 恢复任务
- (IBAction)startBackground:(id)sender;   // 后台任务

@end

// *************************************************
// SCViewController.m
#import "SCViewController.h"
#import "SCAppDelegate.h"

@interface SCViewController () <NSURLSessionDownloadDelegate> {
    NSURLSessionDownloadTask *cancellableTask; // 可取消任务
    NSURLSession *inProcessSession; // 私有会话
    NSData *partialDownload; // 可恢复任务下载的临时数据
}

@end

@implementation SCViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// 从 nib 文件加载视图后，进行额外的初始化工作
    self.progressIndicator.hidden = YES;
    self.progressIndicator.progress = 0;
    
    // Make sure that we've attached to the background session
    self.backgroundSession.sessionDescription = @"Background session";
}

#pragma mark - Custom Accessors
// 后台会话，单例类
- (NSURLSession *)backgroundSession
{
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
// 开始任务
- (IBAction)startCancellable:(id)sender {
    if (!cancellableTask) {
        if(!inProcessSession) {
            // 创建默认会话
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                             delegate:self
                                                        delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        // Image CreativeCommons courtesy of flickr.com/charliematters
        NSString *url = @"http://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        // 创建可取消任务
        cancellableTask = [inProcessSession downloadTaskWithRequest:request];
        
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
        
        // 开启下载任务
        [cancellableTask resume];
    }
}

// 取消任务
- (IBAction)cancelCancellable:(id)sender {
    if(cancellableTask) {
        // 1. 可取消任务
        [cancellableTask cancel];
        cancellableTask = nil;
    } else if(self.resumableTask) {
        // 2. 可恢复任务
        [self.resumableTask cancelByProducingResumeData:^(NSData *resumeData) {
            // ❇️ 缓存已下载数据
            partialDownload = resumeData;
            self.resumableTask = nil;
        }];
    } else if(self.backgroundTask) {
        // 3. 后台任务
        [self.backgroundTask cancel];
        self.backgroundTask = nil;
    }
}

// 恢复任务
- (IBAction)startResumable:(id)sender {
    if(!self.resumableTask) {
        if(!inProcessSession) {
            // 创建默认会话
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        if(partialDownload) {
            // 1. 如果存在缓存数据，继续下载此任务
            self.resumableTask = [inProcessSession downloadTaskWithResumeData:partialDownload];
        } else {
            // 2. 如果不存在缓存，新建可恢复任务
            // Image CreativeCommons courtesy of flickr.com/charliematters
            NSString *url = @"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            // 创建可恢复任务
            self.resumableTask = [inProcessSession downloadTaskWithRequest:request];
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
    NSString *url = @"http://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // self.backgroundSession 是单例对象
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    
    [self setDownloadButtonsAsEnabled:NO];
    self.imageView.hidden = YES;
    
    // 开启下载任务
    [self.backgroundTask resume];
}

#pragma mark - Private
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
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // We've successfully finished the download. Let's save the file
    // 保存到文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    NSError *error;
    
    // 先删除文件中已经存在的任何文件
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
    
    // ❇️ 会话置空，解除循环引用
    if(downloadTask == cancellableTask) {
        cancellableTask = nil;
    } else if (downloadTask == self.resumableTask) {
        self.resumableTask = nil;
        partialDownload = nil;
    } else if (session == self.backgroundSession) {
        // 后台会话
        self.backgroundTask = nil;
        // Get hold of the app delegate
        SCAppDelegate *appDelegate = (SCAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.backgroundURLSessionCompletionHandler) {
            // Need to copy the completion handler
            void (^handler)() = appDelegate.backgroundURLSessionCompletionHandler;
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
```

开启后台下载任务时，即使关闭了应用程序，这个下载任务依然在后台运行。

当这个下载任务完成后，iOS将会重新启动app来让任务知道，对这个我们不必放在心上。为了达到这个目的，我们可以在app的代理中调用下面的代码:

```objective-c
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    self.backgroundURLSessionCompletionHandler = completionHandler;
}
```

### 效果

![](http://upload-images.jianshu.io/upload_images/2648731-26ce50a3e3637801.gif?imageMogr2/auto-orient/strip)


### 参考：

- [GitHub: shinobicontrols/iOS7-day-by-day](https://github.com/ShinobiControls/iOS7-day-by-day)