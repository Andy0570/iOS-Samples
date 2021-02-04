//
//  HQLDemo2ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo2ViewController.h"

@interface HQLDemo2ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@end

@implementation HQLDemo2ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 创建一个下载任务

- (IBAction)createDownloadTask:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf"];

    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.myapp.networking.background"];

    // 2.创建 NSURLSession
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:operationQueue];

    // 3.创建 NSURLSessionDownloadTask
    NSURLSessionDownloadTask *downloadTask = [backgroundSession downloadTaskWithURL:url];
    [downloadTask resume];
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"Session %@ download task %@ wrote an additional %lld bytes (total %lld bytes) out of an expected %lld bytes.\n", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n", session, downloadTask, fileOffset, expectedTotalBytes);
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n", session, downloadTask, location);
 
    // Perform the completion handler for the current session
    //self.completionHandlers[session.configuration.identifier]();
 
    // Open the downloaded file for reading
    // 打开下载的文件用于读操作
    NSError *readError = nil;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:location error:&readError];
    // ...
 
   // Move the file to a new URL
    // 将文件移动到新的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectory = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSError *moveError = nil;
    if ([fileManager moveItemAtURL:location toURL:cacheDirectory error:&moveError]) {
        // ...
    }
}


@end
