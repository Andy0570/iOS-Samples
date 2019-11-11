//
//  HQLImageStore.m
//  HQLHomepwner
//
//  Created by ToninTech on 2016/12/2.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLImageStore.h"

@interface HQLImageStore ()

// 存储照片
@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation HQLImageStore

#pragma mark - Lifecycle
#pragma 单例类
+ (instancetype)sharedStore{
    static HQLImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// 私有化方法
- (instancetype) initPrivate{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        // 注册内存过低警告通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

// 不允许直接调用init方法
- (instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HqlImageStore sharedStored]"
                                 userInfo:nil];
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    // 用于保存 NSError 对象地址的局部指针变量
//    NSError *error;
//    NSString *someString = @"Text Data";
//    BOOL success = [someString writeToFile:@"some/path/file"
//                                atomically:YES
//                                  encoding:NSUTF8StringEncoding
//                                     error:&error];
//    if (!success) {
//        NSLog(@"Error writing file:%@",[error localizedDescription]);
//    }
//    
//    NSString *myEssay = [[NSString alloc] initWithContentsOfFile:@"/some/path/file"
//                                                        encoding:NSUTF8StringEncoding error:&error];
//    if (!myEssay) {
//        NSLog(@"Error reading file:%@",[error localizedDescription]);
//    }
    

}

#pragma mark - Custom Accessors
#pragma setter、getter 方法

- (void)setImage:(UIImage *)image forKey:(NSString *)key{
//    [self.dictionary setObject:image forKey:key];
    //下标语法，同上
    self.dictionary[key] = image;
    
    // 获取图片路径并保存图片
    NSString *imagePath = [self imagePathForKey:key];
    // 从图片提取 JPEG 格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    // 将 JPEG 格式的数据写入文件
    // atomically 传入 YES 会先将数据缓存入临时文件，然后等写入操作成功后再将文件移至第一个实参所指定的路径，并覆盖已有的文件。这样，即使应用在写入文件的过程中崩溃，也不会损坏现之前已经保存的同名数据
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key{
//    return [self.dictionary objectForKey:key];
    //下标语法，同上
//    return self.dictionary[key];
    
    // 先尝试通过字典对象获取图片
    UIImage *result = self.dictionary[key];
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        // 通过文件创建 UIImage 对象
        result = [UIImage imageWithContentsOfFile:imagePath];
        // 如果能够通过文件创建图片，就将其放入缓存
        if (result) {
            self.dictionary[key] = result;
        }else {
            NSLog(@"Error:unable to find %@",[self imagePathForKey:key]);
        }
    }
    return result;
}


#pragma mark - Public

// 删除图片
- (void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}


#pragma mark - Private

// 根据传入的键创建相应的文件路径
- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note {
    NSLog(@"flushing %ld images out of the chche",[self.dictionary count]);
    [self.dictionary removeAllObjects];
}
@end
