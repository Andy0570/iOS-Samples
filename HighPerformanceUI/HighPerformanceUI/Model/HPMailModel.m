//
//  HPMailModel.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/6.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailModel.h"

@interface HPMailModel ()

@property (nonatomic, copy, readwrite) NSString *email;
@property (nonatomic, copy, readwrite) NSString *subject;
@property (nonatomic, copy, readwrite) NSString *date;
@property (nonatomic, copy, readwrite) NSString *snippet;
@property (nonatomic, assign, readwrite) HPMailModelStatus mailStatus;
@property (nonatomic, assign, readwrite) BOOL hasAttachment;

@end

@implementation HPMailModel

#pragma mark - Init

- (instancetype)initWithEmail:(NSString *)email
                      subject:(NSString *)subject
                         date:(NSString *)date
                      snippet:(NSString *)snippet
                  emailStatus:(HPMailModelStatus)status
                hasAttachment:(BOOL)hasAttachment {
    self = [super init];
    if (self) {
        _email         = [email copy];
        _subject       = [subject copy];
        _date          = [date copy];
        _snippet       = [snippet copy];
        _mailStatus    = status;
        _hasAttachment = hasAttachment;
    }
    return self;
}

- (instancetype)init {
    return [self initWithEmail:nil
                       subject:nil
                          date:nil
                       snippet:nil
                   emailStatus:HPMailModelStatusUnread
                 hasAttachment:NO];
}

@end
