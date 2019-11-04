//
//  HQLScaryBugDoc.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HQLScaryBugDoc.h"
#import "HQLScaryBugData.h"
#import "HQLScaryBugDatabase.h"

#define KDataKey  @"Data"
#define KDataFile @"data.plist"
#define KThumbImageFile @"thumbImage.jpg"
#define KFullImageFile  @"fullImage.jpg"

@implementation HQLScaryBugDoc

#pragma mark - Lifecycle

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
    self = [super init];
    if (self) {
        _data = [[HQLScaryBugData alloc] initWithTitle:title rating:rating];
        _thumbImage = thumbImage;
        _fullImage  = fullImage;
    }
    return self;
}

#pragma mark - Custom Accessros

- (HQLScaryBugData *)data {
    // 1.如果 data 已经加载到内存中，返回
    if (_data) {
        return _data;
    }
    
    // 2.如果 data 不存在，从指定路径中(***/data.plist)获取 NSData 类型数据
    NSString *dataPath = [_docPath stringByAppendingPathComponent:KDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (!codedData) {
        return nil;
    }
    
    // 3.将获取到的 NSData 类型数据解码
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:KDataFile];
    [unarchiver finishDecoding];
    
    return _data;
}

- (UIImage *)thumbImage {
    if (_thumbImage) {
        return _thumbImage;
    }
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:KThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
}

- (UIImage *)fullImage {
    if (_fullImage) {
        return _fullImage;
    }
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:KFullImageFile];
    return [UIImage imageWithContentsOfFile:fullImagePath];
}

#pragma mark - Pubilc

- (void)saveData {
    if (!_data) {
        return;
    }
    
    // 1.创建文件路径
    [self createDataPath];
    
    // 2.归档:***/data.plist
    NSString *dataPath = [_docPath stringByAppendingPathComponent:KDataFile];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:KDataFile];
    [archiver finishEncoding];
    
    [data writeToFile:dataPath atomically:YES];
}

// 保存图片到磁盘
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
        NSLog(@"Error removing document path:%@",error.localizedDescription);
    }
}

#pragma mark - Private

// 创建文件路径，并作判断
- (BOOL)createDataPath {
    if (!_docPath) {
        self.docPath = [HQLScaryBugDatabase nextScaryBugDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@",[error localizedDescription]);
    }
    return success;
}

@end
