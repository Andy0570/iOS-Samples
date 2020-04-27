//
//  HQLTableViewCellGroupedModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright (c) 2020 独木舟的木 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

/**
 UITableViewStyleGrouped 数据源模型
 
 模型数据源文件：mainTableViewTitleModel.plist
 */
@interface HQLTableViewCellGroupedModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSArray *cells; // NSArray<HQLTableViewCellStyleDefaultModel>

@end
