//
//  HQLFileManagerViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/27.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLFileManagerViewController.h"

@interface HQLFileManagerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HQLFileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"打印目录路径";
    
    [self printDocumentsPath];
}

// 打印常见的文件路径
- (void)printDocumentsPath {
    // 使用 NSFileManager 管理文件系统
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    // MARK: 1.捆绑包目录
    NSString *bundleString = [NSString stringWithFormat:@"bundlePath:%@\n",[NSBundle mainBundle].bundlePath];
    [mutableString appendString:bundleString];
    
    // MARK: 2.沙盒主目录
    NSString *homeDir = NSHomeDirectory();
    NSString *homeDirString = [NSString stringWithFormat:@"homeDir:%@\n",homeDir];
    [mutableString appendString:homeDirString];
    
    // MARK: 3.Documents目录
    NSString *documentsUrlString = [NSString stringWithFormat:@"Documents url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:documentsUrlString];
    
    NSString *documentsPathaString = [NSString stringWithFormat:@"Documents pathA: %@\n",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:documentsPathaString];
    
    NSString *documentsPathbString = [NSString stringWithFormat:@"Documents pathB:%@\n",[homeDir stringByAppendingPathComponent:@"Documents"]];
    [mutableString appendString:documentsPathbString];
    
    // MARK: 4.Library目录
    NSString *libraryUrlString = [NSString stringWithFormat:@"Library url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:libraryUrlString];
    
    NSString *libraryPathaString = [NSString stringWithFormat:@"Library pathA:%@\n",NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:libraryPathaString];
    
    NSString *libraryPathbString = [NSString stringWithFormat:@"Library pathB:%@\n",[homeDir stringByAppendingPathComponent:@"Library"]];
    [mutableString appendString:libraryPathbString];
    
    // MARK: 5.Caches目录
    NSString *cachesUrlString = [NSString stringWithFormat:@"Caches url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:cachesUrlString];
    
    NSString *cachesPathString = [NSString stringWithFormat:@"Caches path:%@\n",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:cachesPathString];
    
    // MARK: 6.tep目录
    NSString *tmpAString = [NSString stringWithFormat:@"tmpA:%@\n",NSTemporaryDirectory()];
    [mutableString appendString:tmpAString];
    
    NSString *tmpBString = [NSString stringWithFormat:@"tmpB:%@\n",[homeDir stringByAppendingPathComponent:@"tmp"]];
    [mutableString appendString:tmpBString];

    self.label.text = mutableString;
}

/*
 // 1.捆绑包目录
 bundlePath:/private/var/containers/Bundle/Application/A0BB8121-51FA-4302-A650-425459A391F1/HQLTableViewDemo.app
 
 // 2.沙盒主目录
 homeDir:/var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1
 
 // 3.Documents目录
 Documents url:  file:///var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Documents/
 Documents pathA:       /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Documents
 Documents pathB:       /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Documents
 
 // 4.Library目录
 Library url:    file:///var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Library/
 Library pathA:         /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Library
 Library pathB:         /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Library
 
 // 5.Caches目录
 Caches url      file:///var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Library/Caches/
 Caches path:           /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/Library/Caches
 
 // 6.tep目录
 tmpA:    /private/var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/tmp/
 tmpB:            /var/mobile/Containers/Data/Application/3DFE48CE-6C32-4643-B0EA-773708B281A1/tmp
 
 */



@end
