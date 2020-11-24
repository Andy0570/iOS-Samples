//
//  HQLPropertyListStore.m
//  iOS Project
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLPropertyListStore.h"
#import <Mantle.h>

@interface HQLPropertyListStore ()
@property (nonatomic, readwrite, copy) NSArray *dataSourceArray;
@end

@implementation HQLPropertyListStore

#pragma mark - Initialize

- (instancetype)initWithPlistFileName:(NSString *)fileName modelsOfClass:(Class)modelClass {
    self = [super init];
    if (self) {
        [self loadPlistFile:fileName modelsOfClass:modelClass];
    }
    return self;
}

- (instancetype)initWithJSONFileName:(NSString *)fileName modelsOfClass:(Class)modelClass {
    self = [super init];
    if (self) {
        [self loadJSONFile:fileName modelsOfClass:modelClass];
    }
    return self;
}

#pragma mark - Private

- (void)loadPlistFile:(NSString *)fileName modelsOfClass:(Class)modelClass {
    NSArray *jsonArray = [self readLocalPlistFile:fileName];
    [self convertJSONArray:jsonArray toModelsOfClass:modelClass];
}

- (void)loadJSONFile:(NSString *)fileName modelsOfClass:(Class)modelClass {
    NSArray *jsonArray = [self readLocalJSONFile:fileName];
    [self convertJSONArray:jsonArray toModelsOfClass:modelClass];
}

// 读取 plist 文件
- (NSArray *)readLocalPlistFile:(NSString *)fileName {
    // 1.构造 plist 文件 URL 路径
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *url = [bundleURL URLByAppendingPathComponent:fileName];
    
    // 2.读取 plist 文件，并存放进 jsonArray 数组
    NSArray *jsonArray;
    if (@available(iOS 11.0, *)) {
        NSError *readFileError = nil;
        jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
        NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
    } else {
        jsonArray = [NSArray arrayWithContentsOfURL:url];
        NSAssert(jsonArray, @"NSPropertyList File read error.");
    }
    
    return jsonArray;
}

// 读取本地 JSON 文件，如：city.json
- (NSArray *)readLocalJSONFile:(NSString *)fileName {
    // 1.构造 json 文件路径
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *url = [bundleURL URLByAppendingPathComponent:fileName];
    
    // 2.将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    // 3.对数据进行 JSON 格式化并返回字典形式
    NSError *readFileError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&readFileError];
    NSAssert1(jsonArray, @"JSON File read error:\n%@", readFileError);
    
    return jsonArray;
}

// 将 JSON 数据转换为 Model
- (void)convertJSONArray:(NSArray *)jsonArray toModelsOfClass:(Class)modelClass {
    if ([modelClass isSubclassOfClass:MTLModel.class]) {
        NSError *decodeError = nil;
        self.dataSourceArray = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:jsonArray error:&decodeError];
        NSAssert1(_dataSourceArray, @"JSONArray decode error:\n%@", decodeError);
    } else {
        NSAssert(NO, @"Unsupported Class Types.");
    }
}

@end
