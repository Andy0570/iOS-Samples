//
//  HQLConvertPathViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/28.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLConvertPathViewController.h"

@interface HQLConvertPathViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HQLConvertPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"路径类型转换";
    
    [self convertPath];
}

// NSURL <——> NSString
- (void)convertPath {
    
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // -------------------------------------------
    // 创建 NSURL 类型的 documentsURL 路径
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSLog(@"documentsURL:%@",documentsURL);
    
    // NSURL ——> NSString
    NSString *documentsPath = documentsURL.path;
    NSLog(@"documentsPath:%@",documentsPath);
    
    // NSURL ——> File Reference URL
    // file reference URL 使用唯一 ID 来标识文件或目录位置。
    NSURL *fileReferenceURL = documentsURL.fileReferenceURL;
    NSLog(@"fileReferenceURL:%@",fileReferenceURL);
    
    // -------------------------------------------
    // 创建 NSString 类型的 documents 路径
    NSString *documentsString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"documentsString:%@",documentsString);
    
    // NSString ——> NSURL
    NSURL *documentsStringToURL = [NSURL fileURLWithPath:documentsString];
    NSLog(@"documentsStringToURL:%@",documentsStringToURL);
    
}

/*
 documentsURL:     file:///var/mobile/Containers/Data/Application/08ACC9E7-9FA9-4B02-B2A7-97145009CBB6/Documents/
 
 documentsPath:           /var/mobile/Containers/Data/Application/08ACC9E7-9FA9-4B02-B2A7-97145009CBB6/Documents
 
 fileReferenceURL: file:///.file/id=16777220.29145396/
 
 documentsString:         /var/mobile/Containers/Data/Application/8F2BCE69-888C-41CB-880F-24573C0FBFF9/Documents
 
 documentsStringToURL:file:///var/mobile/Containers/Data/Application/8F2BCE69-888C-41CB-880F-24573C0FBFF9/Documents/
 */

@end
