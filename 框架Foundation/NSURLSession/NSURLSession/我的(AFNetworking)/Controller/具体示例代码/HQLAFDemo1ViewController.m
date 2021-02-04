//
//  HQLAFDemo1ViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAFDemo1ViewController.h"

// Frameworks
#import <AFNetworking.h>

@interface HQLAFDemo1ViewController ()

@end

@implementation HQLAFDemo1ViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


// MARK: 下载任务
- (IBAction)createDownloadTask:(id)sender {
    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // 2.创建 AFURLSessionManager 对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // 3.创建 NSURL、NSURLRequest 对象
    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    // 4.创建 NSURLSessionDownloadTask 对象
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 下载数据的目标路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // 下载完成后调用
        NSLog(@"File downloaded to: %@", filePath);
    }];
    // 5.开启下载任务
    [downloadTask resume];
}

// 文件下载
- (void)downloadFileExample {
    // 1.创建一个管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2. 创建请求对象
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_03.png"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3. 下载文件
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    // downloadProgress.completedUnitCount 当前下载大小
    // downloadProgress.totalUnitCount 总大小
    NSLog(@"%f", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // targetPath  临时存储地址
        NSLog(@"targetPath:%@",targetPath);
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSLog(@"path:%@",filePath);
        // 返回url 我们想要存储的地址
        // response 响应头
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成之后调用
        // response 响应头
        // filePath 下载存储地址
        NSLog(@"filePath:%@",filePath);
    }];
    // 需要手动开启
    [downloadTask resume];
}


// MARK: 上传任务
- (IBAction)createUploadTask:(id)sender {
    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // 2.创建 AFURLSessionManager 对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // 3.创建 NSURL、NSURLRequest 对象
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    // 4.创建 NSURLSessionUploadTask 对象
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    // 5.开启上传任务
    [uploadTask resume];
}

// 图片上传示例
- (void)uploadImageExample {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url =@"http://120.25.226.186:32812/upload";
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData 将要上传的数据
        UIImage *image =[UIImage imageNamed:@"123"];
        NSData *data =UIImagePNGRepresentation(image);
        
        // 1. formData 直接添加 data 数据
        // 方法一
        /**
          data:上传文件二进制数据
          name:接口的名字
          fileName:文件上传到服务器之后叫什么名字
          mineType:上传文件的类型，可以上传任意二进制mineType.
         */
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        // 方法二
        /**
         data:上传文件二进制数据
         name:接口的名字
         这种方法内部会将文件名当做上传到服务器之后的名字，并自动获取其类型
         */
        [formData appendPartWithFormData:data name:@"file"];
        
        // 2. formData 直接添加 url
//        // formData 将要上传的数据
//        // 直接传URL
//        NSURL *url =[NSURL fileURLWithPath:@"/Users/yangboxing/Desktop/Snip20160905_7.png"];
//        // 方法一
//        [formData appendPartWithFileURL:url name:@"file" fileName:@"hhaha.png" mimeType:@"image/png" error:nil];
//        // 方法二
//        /**
//         这个方法会自动截取url最后一块的文件名作为上传到服务器的文件名
//         也会自动获取mimeType，如果没有办法获取mimeType 就使用@"application/octet-stream" 表示任意的二进制数据 ，当我们不在意文件类型的时候 也可以用这个。
//         */
//        [formData appendPartWithFileURL:url name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 上传成功
        NSLog(@"上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 上传失败
        NSLog(@"上传失败");
    }];
}


// MARK: 创建包含多个信息的有进度指示的上传任务
- (IBAction)createUploadTaskWithMultiPartRequest:(id)sender {
    // 1.创建 NSMutableURLRequest 对象，并设置一系列参数
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        } error:nil];

    // 2.创建 AFURLSessionManager 对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    // 3.创建 NSURLSessionUploadTask 对象
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // 此处不会在主线程上回调
                      // 你要负责在主线程上更新 UI
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];

    [uploadTask resume];
}


// MARK: 创建 Data 任务
- (IBAction)createDataTask:(id)sender {
    // 1.创建 NSURLSessionConfiguration 对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 2.创建 AFURLSessionManager 对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // 3.创建 NSURL、NSURLRequest 对象
    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    
    // 4.创建 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    // 5.开启下载任务
    [dataTask resume];
}

@end
