//
//  HQLConvertPathViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/9.
//

#import "HQLConvertPathViewController.h"

@interface HQLConvertPathViewController ()

@end

@implementation HQLConvertPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self convertPath];
}

// NSURL <——> NSString
- (void)convertPath {
    // -------------------------------------------
    // 创建 NSURL 类型的 documents 路径
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSLog(@"documentsURL:%@\n",documentsURL);
    
    // NSURL -> NSString
    NSString *documentsPath = documentsURL.path;
    NSLog(@"NSURL -> NSString:%@",documentsPath);
    
    // NSURL ——> File Reference URL
    // file reference URL 使用唯一 ID 来标识文件或目录位置
    NSURL *fileReferenceURL = documentsURL.fileReferenceURL;
    NSLog(@"NSURL ——> File Reference URL:%@",fileReferenceURL);
    
    // -------------------------------------------
    // 创建 NSString 类型的 documents 路径
    NSString *documentsString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"documentsString:%@",documentsString);
    
    // NSString ——> NSURL
    NSURL *documentsStringToURL = [NSURL fileURLWithPath:documentsString];
    NSLog(@"NSString ——> NSURL:%@",documentsStringToURL);
}

@end

/*
 documentsURL: file:///var/mobile/Containers/Data/Application/602D4CA8-F567-4639-9DF2-7536DC40910B/Documents/
 
 NSURL -> NSString:  /var/mobile/Containers/Data/Application/602D4CA8-F567-4639-9DF2-7536DC40910B/Documents
 
 NSURL ——> File Reference URL: file:///.file/id=16777220.80637124/
 
 documentsString:          /var/mobile/Containers/Data/Application/602D4CA8-F567-4639-9DF2-7536DC40910B/Documents
 
 NSString ——> NSURL: file:///var/mobile/Containers/Data/Application/602D4CA8-F567-4639-9DF2-7536DC40910B/Documents/
 */
