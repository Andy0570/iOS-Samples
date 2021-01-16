//
//  FMDBManager.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "FMDBManager.h"
#import "NSFileManager+Database.h"

static FMDBManager *_sharedInstance = nil;

@implementation FMDBManager

+ (FMDBManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    NSURL *commonQueueURL = [NSFileManager commonDatabaseURL];
    self.commonQueue = [FMDatabaseQueue databaseQueueWithURL:commonQueueURL];
    
    NSURL *messageQueueURL = [NSFileManager messageDatabaseURL];
    self.messageQueue = [FMDatabaseQueue databaseQueueWithURL:messageQueueURL];
    
    return self;
}

@end
