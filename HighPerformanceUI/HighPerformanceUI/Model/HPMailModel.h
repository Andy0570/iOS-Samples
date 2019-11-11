//
//  HPMailModel.h
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/6.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HPMailModelStatus) {
    HPMailModelStatusUnread,
    HPMailModelStatusRead,
    HPMailModelStatusReplied,
};

/**
 邮箱模型
 */
@interface HPMailModel : NSObject

@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *subject;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSString *snippet;
@property (nonatomic, assign, readonly) HPMailModelStatus mailStatus;
@property (nonatomic, assign, readonly) BOOL hasAttachment;
@property (nonatomic, assign, readwrite) BOOL isMailSelected;

- (instancetype)initWithEmail:(NSString *)email
                      subject:(NSString *)subject
                         date:(NSString *)date
                      snippet:(NSString *)snippet
                  emailStatus:(HPMailModelStatus)status
                hasAttachment:(BOOL)hasAttachment;

@end
