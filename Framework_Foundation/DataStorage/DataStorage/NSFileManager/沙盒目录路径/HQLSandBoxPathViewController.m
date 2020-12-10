//
//  HQLSandBoxPathViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/9.
//

#import "HQLSandBoxPathViewController.h"

@interface HQLSandBoxPathViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation HQLSandBoxPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self printSandBoxPath];
}

// 打印常见的文件路径
- (void)printSandBoxPath {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    // 1.应用包 bundle 目录
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *bundleString = [NSString stringWithFormat:@"bundlePath:%@\n",bundlePath];
    [mutableString appendString:bundleString];
    [mutableString appendString:@"\n"];
    
    // 资源文件夹目录
    // 实际测试，resourcePath 和 bundlePath 是同一个目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *resourceString = [NSString stringWithFormat:@"resourcePath:%@\n",resourcePath];
    [mutableString appendString:resourceString];
    [mutableString appendString:@"\n"];
    
    // 2.沙盒主目录
    NSString *homeDir = NSHomeDirectory();
    NSString *homeDirString = [NSString stringWithFormat:@"homeDir:%@\n",homeDir];
    [mutableString appendString:homeDirString];
    [mutableString appendString:@"\n"];
    
    // 3.Documents 目录
    // 在应用中，用户的数据可以放在这里。在备份和恢复设备的时候，会包括此目录。
    NSString *documentsUrlString = [NSString stringWithFormat:@"Documents url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:documentsUrlString];
    
    NSString *documentsPathaString = [NSString stringWithFormat:@"Documents pathA: %@\n",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:documentsPathaString];
    
    NSString *documentsPathbString = [NSString stringWithFormat:@"Documents pathB:%@\n",[homeDir stringByAppendingPathComponent:@"Documents"]];
    [mutableString appendString:documentsPathbString];
    [mutableString appendString:@"\n"];
    
    // 4.Library 目录
    NSString *libraryUrlString = [NSString stringWithFormat:@"Library url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:libraryUrlString];
    
    NSString *libraryPathaString = [NSString stringWithFormat:@"Library pathA:%@\n",NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:libraryPathaString];
    
    NSString *libraryPathbString = [NSString stringWithFormat:@"Library pathB:%@\n",[homeDir stringByAppendingPathComponent:@"Library"]];
    [mutableString appendString:libraryPathbString];
    [mutableString appendString:@"\n"];
    
    // 5.Caches目录
    NSString *cachesUrlString = [NSString stringWithFormat:@"Caches url:%@\n",[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject];
    [mutableString appendString:cachesUrlString];
    
    NSString *cachesPathString = [NSString stringWithFormat:@"Caches path:%@\n",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject];
    [mutableString appendString:cachesPathString];
    [mutableString appendString:@"\n"];
    
    // 6.Temporary 目录
    // 主要存放临时文件。在设备的备份和恢复时，不会备份此目录。而且此目录下的文件，可能会在应用退出后被删除。
    NSString *tmpAString = [NSString stringWithFormat:@"tmpA:%@\n",NSTemporaryDirectory()];
    [mutableString appendString:tmpAString];
    
    // !!!: 不建议使用
    NSString *tmpBString = [NSString stringWithFormat:@"tmpB:%@\n",[homeDir stringByAppendingPathComponent:@"tmp"]];
    [mutableString appendString:tmpBString];
    [mutableString appendString:@"\n"];
    
    self.textView.text = mutableString;
    NSLog(@"%@",mutableString);
}

@end

/*
 // 1.捆绑包目录
 bundlePath:/private/var/containers/Bundle/Application/C96C10F1-D1EB-434E-9581-1D4D2DA6F58F/DataStorage.app
 
 // 资源文件夹
 resourcePath:/private/var/containers/Bundle/Application/C96C10F1-D1EB-434E-9581-1D4D2DA6F58F/DataStorage.app
 
 // 2.沙盒主目录
 homeDir:/var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69
 
 // 3.Documents目录
 Documents url:  file:///var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Documents/
 Documents pathA:       /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Documents
 Documents pathB:       /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Documents
 
 // 4.Library目录
 Library url:    file:///var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Library/
 Library pathA:         /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Library
 Library pathB:         /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Library
 
 // 5.Caches目录
 Caches url      file:///var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Library/Caches/
 Caches path:           /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/Library/Caches
 
 // 6.Temporary 目录
 tmpA:    /private/var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/tmp/
 tmpB:    /var/mobile/Containers/Data/Application/76436EC6-A38F-4D40-B5E9-02F55F472B69/tmp
 
 !!!: tmpA 是通过 NSTemporaryDirectory() 函数获得的目录，它在 /private/... 路径下
 !!!: tmpB 是我通过 homeDir 拼接方式获得的目录，实际上不在同一个路径下，因此不建议使用此方法
 */
