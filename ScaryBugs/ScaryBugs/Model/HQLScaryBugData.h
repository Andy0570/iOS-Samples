//
//  HQLScaryBugData.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 模型类
 包含错误名称和评级
 */
@interface HQLScaryBugData : NSObject <NSCoding> // #1 遵守 NSCoding 协议

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) float rating;

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating;

@end
