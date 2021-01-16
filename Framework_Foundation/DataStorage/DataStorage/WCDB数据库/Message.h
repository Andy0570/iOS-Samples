//
//  Message.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property (nonatomic, assign) int localID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSDate *createTime;
@property (nonatomic, retain) NSDate *modifiedTime;
@property (nonatomic, assign) int unused; // You can only define the properties you need

@end

NS_ASSUME_NONNULL_END
