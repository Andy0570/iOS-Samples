//
//  GHIssueV1.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "GHIssueV1.h"
#import "GHUser.h"

@implementation GHIssueV1

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

/**
 字典转换为模型时，需要手动从 Dictionary 中取值！
 */
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;

    _URL = [NSURL URLWithString:dictionary[@"url"]];
    _HTMLURL = [NSURL URLWithString:dictionary[@"html_url"]];
    _number = dictionary[@"number"];

    if ([dictionary[@"state"] isEqualToString:@"open"]) {
        _state = GHIssueStateOpen;
    } else if ([dictionary[@"state"] isEqualToString:@"closed"]) {
        _state = GHIssueStateClosed;
    }

    _title = [dictionary[@"title"] copy];
    _retrievedAt = [NSDate date];
    _body = [dictionary[@"body"] copy];
    _reporterLogin = [dictionary[@"user"][@"login"] copy];
    _assignee = [[GHUser alloc] initWithDictionary:dictionary[@"assignee"]];

    _updatedAt = [self.class.dateFormatter dateFromString:dictionary[@"updated_at"]];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;

    _URL = [coder decodeObjectForKey:@"URL"];
    _HTMLURL = [coder decodeObjectForKey:@"HTMLURL"];
    _number = [coder decodeObjectForKey:@"number"];
    _state = [coder decodeIntegerForKey:@"state"];
    _title = [coder decodeObjectForKey:@"title"];
    _retrievedAt = [NSDate date];
    _body = [coder decodeObjectForKey:@"body"];
    _reporterLogin = [coder decodeObjectForKey:@"reporterLogin"];
    _assignee = [coder decodeObjectForKey:@"assignee"];
    _updatedAt = [coder decodeObjectForKey:@"updatedAt"];

    return self;
}

/**
 编码、解码的样板代码也需要自己实现
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.URL != nil) [coder encodeObject:self.URL forKey:@"URL"];
    if (self.HTMLURL != nil) [coder encodeObject:self.HTMLURL forKey:@"HTMLURL"];
    if (self.number != nil) [coder encodeObject:self.number forKey:@"number"];
    if (self.title != nil) [coder encodeObject:self.title forKey:@"title"];
    if (self.body != nil) [coder encodeObject:self.body forKey:@"body"];
    if (self.reporterLogin != nil) [coder encodeObject:self.reporterLogin forKey:@"reporterLogin"];
    if (self.assignee != nil) [coder encodeObject:self.assignee forKey:@"assignee"];
    if (self.updatedAt != nil) [coder encodeObject:self.updatedAt forKey:@"updatedAt"];

    [coder encodeInteger:self.state forKey:@"state"];
}

/**
 copyWithZone: 方法让自定义对象支持 copy 操作
 */
- (id)copyWithZone:(NSZone *)zone {
    GHIssueV1 *issue = [[self.class allocWithZone:zone] init];
    issue->_URL = self.URL;
    issue->_HTMLURL = self.HTMLURL;
    issue->_number = self.number;
    issue->_state = self.state;
    issue->_reporterLogin = self.reporterLogin;
    issue->_assignee = self.assignee;
    issue->_updatedAt = self.updatedAt;

    issue.title = self.title;
    issue->_retrievedAt = [NSDate date];
    issue.body = self.body;

    return issue;
}

- (NSUInteger)hash {
    return self.number.hash;
}

- (BOOL)isEqual:(GHIssueV1 *)issue {
    if (![issue isKindOfClass:GHIssueV1.class]) return NO;

    return [self.number isEqual:issue.number] && [self.title isEqual:issue.title] && [self.body isEqual:issue.body];
}

@end
