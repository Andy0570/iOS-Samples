//
//  HQLFIleManagerUsuallyMethodViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/29.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLFIleManagerUsuallyMethodViewController.h"

@interface HQLFIleManagerUsuallyMethodViewController ()

@end

@implementation HQLFIleManagerUsuallyMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 确定文件是否存在

- (BOOL)isFileExists{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];

    return fileExists;
}

#pragma mark - 列出目录里面的所有文件

- (void)getAllFileInDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'png'"];
    for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {
        // 在目录中枚举 .png 文件
    }
}

#pragma mark - 在目录中递归地遍历文件

- (void)enumerateFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:bundleURL
                                          includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL *url, NSError *error)
    {
        if (error) {
            NSLog(@"[Error] %@ (%@)", error, url);
            return NO;
        }

        return YES;
    }];

    NSMutableArray *mutableFileURLs = [NSMutableArray array];
    for (NSURL *fileURL in enumerator) {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];

        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];

        // Skip directories with '_' prefix, for example
        if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
            [enumerator skipDescendants];
            continue;
        }

        if (![isDirectory boolValue]) {
            [mutableFileURLs addObject:fileURL];
        }
    }
}

#pragma mark - 创建一个目录

- (void)createDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagesPath = [documentsPath stringByAppendingPathComponent:@"images"];
    if (![fileManager fileExistsAtPath:imagesPath]) {
        [fileManager createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}


#pragma mark - 删除一个目录

- (void)removeDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    NSError *error = nil;

    if (![fileManager removeItemAtPath:filePath error:&error]) {
        NSLog(@"[Error] %@ (%@)", error, filePath);
    }
}

#pragma mark - 删除文件的创建日期

- (void)removeFileCreateDate {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"Document.pages"];

    NSDate *creationDate = nil;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        creationDate = attributes[NSFileCreationDate];
    }
}

#pragma mark - 将文件放到 iCloud 里面

- (void)saveFileToiCloud {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSURL *fileURL = [NSURL fileURLWithPath:[documentsPath stringByAppendingPathComponent:@"Document.pages"]];

        //这里的 identifier 应该设置为 entitlements 的第一个元素；当你使用这段代码的时候需要把 identifier 设置为你自己的真实 identifier
        NSString *identifier = nil;

        NSURL *ubiquitousContainerURL = [fileManager URLForUbiquityContainerIdentifier:identifier];
        NSURL *ubiquitousFileURL = [ubiquitousContainerURL URLByAppendingPathComponent:@"Document.pages"];

        NSError *error = nil;
        BOOL success = [fileManager setUbiquitous:YES
                                        itemAtURL:fileURL
                                   destinationURL:ubiquitousFileURL
                                            error:&error];
        if (!success) {
            NSLog(@"[Error] %@ (%@) (%@)", error, fileURL, ubiquitousFileURL);
        }
    });
}

@end
