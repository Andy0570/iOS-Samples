//
//  FMDBManager.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/14.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBManager : NSObject

/// DB队列（除IM相关）
@property (nonatomic, strong) FMDatabaseQueue *commonQueue;

/// 与IM相关的DB对象
@property (nonatomic, strong) FMDatabaseQueue *messageQueue;

+ (FMDBManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
