//
//  RWTScaryBugDoc.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/22.
//

#import "RWTScaryBugDoc.h"
#import "RWTScaryBugData.h"
#import "RWTScaryBugDatabase.h"

#define KDataKey  @"Data"
#define KDataFile @"data.plist"
#define KThumbImageFile @"thumbImage.jpg"
#define KFullImageFile  @"fullImage.jpg"

@implementation RWTScaryBugDoc

#pragma mark - Initialize

- (void)dealloc {
    _docPath = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithDocPath:(NSString *)docPath {
    if (self = [super init]) {
        _docPath = [docPath copy];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                       rating:(float)rating
                   thumbImage:(UIImage *)thumbImage
                    fullImage:(UIImage *)fullImage {
    if (self = [super init]) {
        _data = [[RWTScaryBugData alloc] initWithTitle:title rating:rating];
        _thumbImage = thumbImage;
        _fullImage = fullImage;
    }
    return self;
}

#pragma mark - Custom Accessors

- (RWTScaryBugData *)data {
    // 1.如果 data 已经加载到内存中，返回
    if (_data) { return _data; }
    
    // 2.如果 data 不存在，从指定路径中(***/data.plist)获取 NSData 类型数据
    NSString *dataPath = [_docPath stringByAppendingPathComponent:KDataFile];
    NSData *archivedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (!archivedData) { return nil; }
    
    // 3.将获取到的 NSData 类型数据解码
    NSError *error = nil;
    _data = [NSKeyedUnarchiver unarchivedObjectOfClass:RWTScaryBugData.class fromData:archivedData error:&error];
    if (error) {
        NSLog(@"unarchiver error: %@", error.localizedDescription);
        return nil;
    }
    
    return _data;
}

- (UIImage *)thumbImage {
    if (_thumbImage) { return _thumbImage; }
    
    // 从磁盘读取图片文件
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:KThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
}

- (UIImage *)fullImage {
    if (_fullImage) { return _fullImage; }
    
    // 从磁盘读取图片文件
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:KFullImageFile];
    return [UIImage imageWithContentsOfFile:fullImagePath];
}

#pragma mark - Public

- (void)saveData {
    if (!_data) { return; }
    
    // 1.创建文件路径
    [self createDataPath];
    
    // 2.归档文件路径:***/data.plist
    NSString *dataPath = [_docPath stringByAppendingPathComponent:KDataFile];
    
    // 3.执行归档
    NSError *error = nil;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_data requiringSecureCoding:YES error:&error];
    if (!archivedData) {
        NSLog(@"归档失败：%@",error.localizedDescription);
        return;
    }
    
    // 4.保存到文件
    [archivedData writeToFile:dataPath atomically:YES];
}

// 保存图片文件到磁盘
- (void)saveImages {
    if (!_thumbImage || !_fullImage) {
        return;
    }
    
    [self createDataPath];
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:KThumbImageFile];
    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:KFullImageFile];
    NSData *fullImageData = UIImagePNGRepresentation(_fullImage);
    [fullImageData writeToFile:fullImagePath atomically:YES];
    
    self.thumbImage = nil;
    self.fullImage = nil;
}

- (void)deleteDoc {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path:%@", error.localizedDescription);
    }
}

#pragma mark - Private

// 创建文件路径，并作判断
- (BOOL)createDataPath {
    if (!_docPath) {
        self.docPath = [RWTScaryBugDatabase nextScaryBugDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", error.localizedDescription);
    }
    return success;
}

@end
