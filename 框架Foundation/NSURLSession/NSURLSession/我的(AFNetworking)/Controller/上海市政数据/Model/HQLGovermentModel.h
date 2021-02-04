//
//  HQLGovermentModel.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 上海市政数据返回条目 - 第三层数据模型
 */
@interface ListData : NSObject

@property (nonatomic, strong) NSString *name; // 项目名称
@property (nonatomic, strong) NSString *addr; // 项目地址
@property (nonatomic, strong) NSString *tel;  // 项目电话号码

@end

/**
 上海市政数据返回数据模型 - 第二层数据模型
 */
@interface ResultData : NSObject

@property (nonatomic, strong) NSString *title; // 数据项名称
@property (nonatomic, strong) NSArray *list;   // Array<ListData>

@end

/**
 返回的上海市政数据模型 - 最顶层数据模型
 */
@interface HQLGovermentModel : NSObject

@property (nonatomic, strong) NSString *resultcode;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) ResultData *result;
@property (nonatomic, strong) NSString *error_code;

@end

NS_ASSUME_NONNULL_END
