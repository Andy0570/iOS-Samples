//
//  RWTScaryBugDatabase.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/23.
//

#import "RWTScaryBugDatabase.h"
#import "RWTScaryBugDoc.h"

@implementation RWTScaryBugDatabase

#pragma mark - Public

+ (NSMutableArray *)loadScaryBugDocs {
    
    // Get private docs dir
    NSString *documentsDirectiory = [RWTScaryBugDatabase getPrivateDocsDir];
    NSLog(@"Loading bugs from %@",documentsDirectiory);
    
    // Get contents of documents directiory 获取文档目录列表
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectiory error:&error];
    if (!files) {
        NSLog(@"Error reading contents of documents directory:%@", error.localizedDescription);
        return nil;
    }
    
    // Create RWTScaryBugDoc for each file
    // Documents/Private Documents/#.scarybug
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        // 判断文件扩展名
        if ([file.pathExtension compare:@"scarybug" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectiory stringByAppendingPathComponent:file];
            RWTScaryBugDoc *doc = [[RWTScaryBugDoc alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    return retval;
}

+ (NSString *)nextScaryBugDocPath {
    
    // Get private docs dir
    NSString *documentsDirectory =[RWTScaryBugDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (!files) {
        NSLog(@"Error reading contents of documents directory:%@",error.localizedDescription);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"scarybug" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.scarybug",maxNumber + 1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}

#pragma mark - Private

// 获取文件路径：../Library/Private Documents/
+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];

    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) { return nil; }
    
    return documentsDirectory;
}

@end
